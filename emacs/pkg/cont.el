;; -*- lexical-binding: t; -*-
;;; cont.el --- Solve problems with stacks.
(require 'bookmark)

;;; Init
(bookmark-maybe-load-default-file)
(defvar cont-cstack-name nil)
(defvar cont--cstack-jind 0)
(defvar cont--cstack-pind nil)
(defvar cont--header "CONT")

;;; Advice
(defun cont--filter-bookmarks-advice (alist)
  "Filter out continuation bookmarks from the provided ALIST."
  (seq-remove (lambda (bm)
                (string-prefix-p (format "%s-" cont--header)
                                 (car bm)))
              alist))
(advice-add 'bookmark-maybe-sort-alist :filter-return #'cont--filter-bookmarks-advice)

;;; Mapping
(defvar cont--help
  "(n)ext | (p)revious | (j)ump | (r)ename | (k)ill | (t) pin | (g) refresh | (q)uit\n")
(defvar cont-list-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "n") #'forward-button)
    (define-key map (kbd "<tab>") #'forward-button)
    (define-key map (kbd "p") #'backward-button)
    (define-key map (kbd "<backtab>") #'backward-button)
    (define-key map (kbd "j") #'push-button)
    (define-key map (kbd "C-<return>") #'push-button)
    (define-key map (kbd "<return>") #'push-button)
    (define-key map (kbd "q") #'quit-window)
    (define-key map (kbd "C-g") #'quit-window)
    (define-key map (kbd "<escape>") #'quit-window)
    (define-key map (kbd "t") #'cont--list-pin-step)
    (define-key map (kbd "r") #'cont--list-rename-step)
    (define-key map (kbd "k") #'cont--list-delete-step)
    (define-key map (kbd "g") #'revert-buffer)
    map))

(defun cont--interact-at-point (proc)
  (lambda ()
    (interactive)
    (let* ((btn (button-at (point)))
           (step (and btn (button-get btn 'step)))
           (stack (and btn (button-get btn 'stack))))
      (if step (funcall proc step stack)
        (message "No step at point.")))))

(defalias 'cont--list-pin-step
  (cont--interact-at-point
   #'(lambda (step stack)
       (cont--set-cstack-pind (cl-position step stack))
       (message (format "Pinned %s" (cont--get-step-name step)))

       (cont-list))))
(defalias 'cont--list-rename-step
  (cont--interact-at-point
   #'(lambda (step _)
       (cont--rename-step step)
       (cont-list))))

(defalias 'cont--list-delete-step
  (cont--interact-at-point
   #'(lambda (step _)
       (cont--delete-step step)
       (if (cont--no-stacks?) (quit-window) (cont-list)))))

;;; Major mode
(define-derived-mode cont-list-mode special-mode "cont"
  "Solve problems with stacks."
  (setq-local revert-buffer-function (lambda (&rest _) (cont-list)))
  (setq font-lock-defaults
        '((("^\\([A-Za-z0-9_-]+\\)" 1 'font-lock-keyword-face)
           ("(\\*)" . 'font-lock-warning-face)
           ("(\\+)" . 'font-lock-warning-face)
           ("^([n|p|j|r|d|g|q]).*" . 'font-lock-comment-face)))))

;;; Helper
(defun cont--ask-switching-from-empty-stack ()
  (when (and (not (cont--nil-cstack-name?))
             (cont--empty-cstack?))
    (unless (y-or-n-p (format "Leaving empty stack [%s] -- proceed?" cont-cstack-name))
      (user-error "Switch cancelled"))))

(defun cont--is-cstack-name? (stack-name)
  (string= stack-name cont-cstack-name))

(defun cont--adorn-pinned-step (step stack)
  (if (and cont--cstack-pind
           cont-cstack-name
           (string= (cont--get-step-stack-name step) cont-cstack-name)
           (= (cl-position step stack) cont--cstack-pind)) " (+)" ""))

(defun cont--adorn-stack-name (stack-name)
  (format "%s %s" stack-name (if (cont--is-cstack-name? stack-name) "(*)" "")))

;;; Objects
;; stack -- a LIFO list of steps (a list of bookmarks)
(defun cont--get-stack (stack-name)
  "Get all bookmarks belonging to STACK-NAME."
  (seq-filter (lambda (step)
                (string= (cont--get-step-stack-name step)
                         stack-name))
              bookmark-alist))

(defun cont--get-all-stack-names ()
  "Return a unique list of all stack names found in bookmark-alist."
  (let (stacks)
    (dolist (b bookmark-alist)
      (let ((stack-name (cont--get-step-stack-name b)))
        (when stack-name (push stack-name stacks))))
    (delete-dups stacks)))
(defun cont--no-stacks? ()
  (= (length (cont--get-all-stack-names)) 0))

;; step -- components of a stack (a bookmark)
(defun cont--make-step (step-name stack-name)
  (let* ((timestamp (format-time-string "%Y%m%d-%H%M%S"))
         (bkmk-name (format "%s-%s-%s" cont--header stack-name timestamp)))
    (bookmark-set bkmk-name)
    (bookmark-prop-set bkmk-name 'cont-stack-name stack-name)
    (bookmark-prop-set bkmk-name 'cont-step-name step-name)
    (bookmark-save)
    (message "Pushed %s to [%s]" step-name stack-name)))

(defun cont--get-step-prop (step prop)
  (bookmark-prop-get step prop))

(defun cont--get-step-stack-name (step)
  (cont--get-step-prop step 'cont-stack-name))

(defun cont--get-step-name (step)
  (cont--get-step-prop step 'cont-step-name))

(defun cont--jump-step (step)
  (bookmark-jump step)
  (message "Switched to %s in [%s]"
           (cont--get-step-name step)
           (cont--get-step-stack-name step)))

(defun cont--pop-step (step)
  (bookmark-delete step)
  (bookmark-save))

(defun cont--delete-step (step)
  (when (y-or-n-p (format "Delete step '%s'? " (cont--get-step-name step)))
    (cont--pop-step step)))

(defun cont--rename-step (step)
  (let* ((old-step-name (cont--get-step-name step))
         (new-step-name (read-string "New name: " old-step-name)))
    (bookmark-prop-set step 'cont-step-name new-step-name)
    (bookmark-save)))

;; cstack-name -- name of current stack
(defun cont--set-cstack-name (stack-name)
  (setq cont-cstack-name stack-name)
  (cont--reset-cstack-jind)
  (cont--reset-cstack-pind)
  (if stack-name
      (message (format "Switching to %s" stack-name))))

(defun cont--reset-cstack-name ()
  (cont--set-cstack-name nil))

(defun cont--nil-cstack-name? ()
  (or (null cont-cstack-name)
      (string= cont-cstack-name "")))

(defun cont--set-cstack-name-if-nil ()
  (when (cont--nil-cstack-name?)
    (cont--set-cstack-name
     (completing-read "Choose a stack: " (cont--get-all-stack-names)))))

;; cstack-jind -- current jump index
(defun cont--reset-cstack-jind ()
  (setq cont--cstack-jind 0))

(defun cont--iter-cstack-jind ()
  (setq cont--cstack-jind (1+ cont--cstack-jind)))

;; cstack-pind -- current pinned index
(defun cont--set-cstack-pind (n)
  (setq cont--cstack-pind n))

(defun cont--reset-cstack-pind ()
  (cont--set-cstack-pind nil))

(defun cont--nil-cstack-pind? ()
  (null cont--cstack-pind))

;; cstack -- current stack
(defun cont--get-cstack ()
  (cont--get-stack cont-cstack-name))

(defun cont--empty-cstack? ()
  (null (cont--get-cstack)))

(defun cont--valid-cstack? ()
  (cond ((cont--no-stacks?)
         (user-error "No stacks."))
        ((cont--nil-cstack-name?)
         (user-error "Choose a stack."))
        ((cont--empty-cstack?)
         (user-error "Stack is empty."))
        (t t)))

;; cstep -- current step
(defun cont--get-cstep ()
  (cont--valid-cstack?)
  (car (cont--get-cstack)))

(defun cont--get-cstep-name ()
  (cont--get-step-name (cont--get-cstep)))

(defun cont--jump-cstep ()
  (cont--jump-step (cont--get-cstep)))

(defun cont--pop-cstep ()
  (cont--pop-step (cont--get-cstep)))

;;; Core
(defun cont-switch (stack-name arg)
  "Switch to an existing stack. Throws error if NAME is unknown."
  (interactive
   (list (progn
           (cont--ask-switching-from-empty-stack)
           (completing-read "Switch to stack: " (cont--get-all-stack-names)))
         current-prefix-arg))
  (cont--set-cstack-name stack-name)
  (if (member stack-name (cont--get-all-stack-names))
      (unless arg (cont--jump-cstep))
    (message "New stack: %s" stack-name)))

(defun cont-push (step-name)
  "Push position to stack. Prompts for stack name if none is active."
  (interactive
   (list (progn
           (cont--set-cstack-name-if-nil)
           (read-string (format "Push to [%s]: " cont-cstack-name)
                        (let ((sym (thing-at-point 'symbol)))
                          (when sym (cons sym 0)))))))
  (cont--make-step step-name cont-cstack-name))

(defun cont-pop ()
  "Pop the most recent step from the active stack after confirmation."
  (interactive)
  (cont--valid-cstack?)
  ;; TODO: Jump to cstep, and jump back if the user cancels
  (if (y-or-n-p (format "Resolve %s in [%s]? " (cont--get-cstep-name) cont-cstack-name))
      (cont--pop-cstep)
    (user-error "Pop cancelled."))
  (if (cont--empty-cstack?)
      (progn
        (message cont-cstack-name)
        (cont--reset-cstack-name))
    (cont--jump-cstep)))

(defun cont-jump ()
  "Snap back to the top (newest step) of the stack."
  (interactive)
  (cont--valid-cstack?)
  (cont--reset-cstack-jind)
  (cont--jump-cstep))

(defun cont-prev ()
  "Jump to the previous (older) step by moving deeper into the stack."
  (interactive)
  (cont--valid-cstack?)
  (let ((cstack (cont--get-cstack)))
    (if (< (1+ cont--cstack-jind) (length cstack))
        (cont--iter-cstack-jind))
    (cont--jump-step (nth cont--cstack-jind cstack))))

(defun cont-pin (n)
  "Jump to the first step (update index)."
  (interactive "P")
  (cont--valid-cstack?)
  (let ((cstack (cont--get-cstack)))
    (when n
      (let ((n (prefix-numeric-value n)))
        (cond ((< n 0) (user-error "Too small"))
              ((> n (1- (length cstack))) (user-error "Too large"))
              (t (cont--set-cstack-pind (- (length cstack) n 1))))))
    (if (cont--nil-cstack-pind?)
        (cont-pin (read-number "Provide an index: "))
      (cont--jump-step (nth cont--cstack-pind cstack)))))

;;; Messaging
(defun cont-steps ()
  "Display all steps in the current stack as a sequence of steps."
  (interactive)
  (cont--valid-cstack?)
  (message (mapconcat 'identity
                      (cons (format "%s:" cont-cstack-name)
                            (mapcar 'cont--get-step-name (cont--get-cstack)))
                      "\n")))

(defun cont-stacks ()
  "List all available stacks in the echo area."
  (interactive)
  (let ((stack-names (cont--get-all-stack-names)))
    (if stack-names
        (message (mapconcat #'cont--adorn-stack-name stack-names "\n"))
      (message "No stacks."))))

(defun cont-list ()
  "Show summary of active stacks. RET to jump, 'd' to delete, etc."
  (interactive)
  (let ((stack-names (cont--get-all-stack-names)))
    (if (null stack-names)
        (user-error "No stacks.")
      (let ((buf (get-buffer-create "*Continuation Stacks*"))
            (active-pos nil))
        (with-current-buffer buf
          (cont-list-mode)
          (let ((inhibit-read-only t))
            (erase-buffer)
            (use-local-map cont-list-mode-map)
            (insert cont--help)
            (dolist (stack-name stack-names)
              (let ((is-cstack (cont--is-cstack-name? stack-name))
                    (stack (cont--get-stack stack-name)))
                (when is-cstack (setq active-pos (point)))
                (insert (format "\n%s\n" (cont--adorn-stack-name stack-name)))
                (dolist (step stack)
                  (let ((step-name (cont--get-step-name step))
                        (filename (cont--get-step-prop step 'filename)))
                    (insert " ")
                    (insert-text-button
                     (format "%s (%s)" step-name (file-name-nondirectory (or filename "No file")))
                     'action (lambda (btn)
                               (let* ((step (button-get btn 'step))
                                      (stack-name (cont--get-step-stack-name step)))
                                 (quit-window)
                                 (cont--set-cstack-name stack-name)
                                 (cont--jump-step step)))
                     'step step
                     'stack stack
                     'follow-link t)
                    (insert (cont--adorn-pinned-step step stack))
                    (insert "\n")))))
            (goto-char (or active-pos (point-min)))
            (forward-button 1)
            (font-lock-flush)))
        (pop-to-buffer buf)))))

(provide 'cont)
