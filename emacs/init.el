;; -*- lexical-binding: t -*-
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'package)
(setq package-archives
      '(("melpa" . "https://melpa.org/packages/")
        ("gnu"   . "https://elpa.gnu.org/packages/")))
(package-initialize)

;; Bootstrap use-package if missing
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun my/use-ivy (proc)
  (interactive)
  (let ((completing-read-function #'ivy-completing-read))
    (call-interactively proc)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package cont
  :load-path "~/workspace/dotfiles/emacs/pkg/"
  :config
  (defun my/cont-switch-ivy ()
    (interactive) (my/use-ivy #'cont-switch))
  :bind
  ("C-c C-S-c C-c" . my/cont-switch-ivy)
  ("C-c C-S-c C-a" . cont-push)
  ("C-c C-S-c C-S-p" . cont-pop)
  ("C-c C-S-c C-t" . cont-pin)
  ("C-c C-S-c C-j" . cont-jump)
  ("C-c C-S-c C-r" . cont-root)
  ("C-c C-S-c C-p" . cont-prev)
  ("C-c C-S-c C-l" . cont-list)
  ("C-c C-S-c C-s" . cont-stacks)
  ("C-c C-S-c C-S-s" . cont-steps))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; https://www.reddit.com/r/emacs/comments/15egjik/emacs291_keymapset_proper_way_to_distinguish_tab/
;; Mouse mode (https://unix.stackexchange.com/a/406519)
;; https://www.gnu.org/software/emacs/manual/html_node/emacs/General-VC-Options.html
;; https://systemcrafters.net/emacs-tips/keeping-folders-clean/
(use-package emacs
  :preface
  (defun my/local-dired-open (orig-fun &rest args)
    (let* ((real-files (dired-get-marked-files nil nil nil nil t))
           (fake-files (mapcar (lambda (fn)
                                 (if (file-remote-p fn)
                                     (let* ((ext (or (file-name-extension fn t) ""))
                                            (tmp (make-temp-file "local-dired-" nil ext)))
                                       (copy-file fn tmp t)
                                       tmp)
                                   fn))
                               real-files)))
      (cl-letf (((symbol-function 'dired-get-marked-files)
                 (lambda (&rest _args) fake-files)))
        (apply orig-fun args))))
  (defun my/display-current-time ()
    (interactive)
    (message (format-time-string "%H:%M %a %b %d %Y")))
  :init
  ;; File
  (setq help-window-select t)
  (setq vc-follow-symlinks t)
  (setq make-backup-files nil)
  (setq create-lockfiles nil)
  (setq dired-dwim-target t)
  (setq dired-listing-switches "-ahlF --time-style=long-iso")
  (setq browse-url-browser-function 'xwidget-webkit-browse-url)
  (setq help-enable-variable-value-editing t)
  ;; (setq global-auto-revert-non-file-buffers t)
  ;; (setq auto-revert-remote-files t)
  ;; Formatting
  (setq completions-format 'vertical)
  (setq image-auto-resize 'fit-window)
  (setq sentence-end-double-space nil)
  (setq my/zoom-step 3)
  (setq my/zoom-state 0)
  (setq my/zoom-states 3)
  (setq imagemagick-types-inhibit t)
  (setq-default indent-tabs-mode nil)
  (setq-default tab-width 2)
  (setq column-number-mode t)
  (setq window-divider-default-right-width 1)
  (setq window-divider-default-bottom-width 1)
  (setq window-divider-default-places t)
  (window-divider-mode 1)
  (winner-mode t)
  ;; Autosave
  (make-directory (expand-file-name "tmp/auto-saves/" user-emacs-directory) t)
  (setq auto-save-list-file-prefix (expand-file-name "tmp/auto-saves/sessions/" user-emacs-directory)
        auto-save-file-name-transforms `((".*" ,(expand-file-name "tmp/auto-saves/" user-emacs-directory) t)))
  :config
  (savehist-mode)
  (save-place-mode t)
  (global-auto-revert-mode t)
  (global-visual-line-mode t)
  (pixel-scroll-precision-mode t)
  (setq frame-resize-pixelwise t)
  (xterm-mouse-mode t)
  (add-hook 'before-save-hook 'delete-trailing-whitespace)
  (add-hook 'prog-mode-hook 'display-line-numbers-mode)
  (add-hook 'org-mode-hook 'display-line-numbers-mode)
  (keymap-set input-decode-map "C-S-i" "C-S-<i>")
  (advice-add 'dired-do-open :around #'my/local-dired-open)
  (fset 'yes-or-no-p 'y-or-n-p)
  (global-unset-key (kbd "C-z"))
  (setq comint-scroll-to-bottom-on-input t)
  (setq comint-scroll-to-bottom-on-output t)
  (setq comint-move-point-for-output t)
  (setq scroll-margin 1)
  :bind
  ("C-S-c" . my/display-current-time)
  ("C-S-z" . (lambda ()
	             (interactive)
               (global-text-scale-adjust (if (< my/zoom-state (- my/zoom-states 1)) my/zoom-step
                                           (* -1 my/zoom-states my/zoom-step)))
               (setq my/zoom-state (% (+ my/zoom-state 1) my/zoom-states))))
  ("M-SPC" . hippie-expand)
  ("C-x C-x" . execute-extended-command)
  ("C-S-k" . kill-buffer-and-window)
  ("C-S-n" . (lambda () (interactive) (message (buffer-name))))
  ("C-S-<i>" . (lambda () (interactive) (find-file "~/.emacs.d/init.el"))))

;; https://github.com/d12frosted/homebrew-emacs-plus?tab=readme-ov-file#system-appearance-changevsl
(use-package doom-themes
  :custom
  (doom-themes-enable-bold t)
  (doom-themes-enable-italic t)
  :preface
  (defun my/apply-theme (appearance)
    (mapc #'disable-theme custom-enabled-themes)
    (pcase appearance
      ('light (load-theme 'doom-moonlight  t)) ;; 'doom-acario-light t))
      ('dark (load-theme 'doom-wilmersdorf t))))
  (defun my/apply-theme-to-frame (frame)
    (with-selected-frame frame
      (when (display-graphic-p)
        (my/apply-theme ns-system-appearance))))
  :config
  (when (display-graphic-p)
    (my/apply-theme ns-system-appearance))
  (add-hook 'ns-system-appearance-change-functions #'my/apply-theme)
  (add-hook 'after-make-frame-functions #'my/apply-theme-to-frame)
  (when (daemonp)
    (add-hook 'after-init-hook
              (lambda ()
                (when (display-graphic-p)
                  (my/apply-theme ns-system-appearance))))))

;; Moodline
(use-package mood-line
  :config
  (mood-line-mode t)
  (defvar my/saved-mode-line nil)
  (defun my/toggle-mode-line ()
    (interactive)
    (if (eq mode-line-format nil)
        (setq-default mode-line-format my/saved-mode-line)
      (progn
        (setq my/saved-mode-line mode-line-format)
        (setq-default mode-line-format nil))))
  :bind
  ("C-S-l" . my/toggle-mode-line))
(my/toggle-mode-line)

;; Dimmer
(use-package dimmer)
(dimmer-configure-which-key)
(dimmer-mode t)
(setq dimmer-fraction 0.4)

;; Pulsar
(use-package pulsar
  :bind
  ("C-S-p" . #'pulsar-highlight-pulse)
  :init
  (pulsar-global-mode t)
  :config
  (setq pulsar-delay 0.002)
  (setq pulsar-iterations 100))

;; Drag-stuff
(use-package drag-stuff
  :config
  (drag-stuff-global-mode t)
  :bind
  ("M-p" . drag-stuff-up)
  ("M-n" . drag-stuff-down))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Emacs server
(use-package server
  :config
  (unless (server-running-p)
    (server-start)))

;; Tab bar
(use-package tab-bar
  :init
  (setq tab-bar-show nil)
  :config
  (tab-bar-mode t)
  :bind
  ("C-S-t" . tab-switcher)
  ("C-M-S-t" . tab-list)
  ("s-t" . tab-new)
  ("s-w" . my/close-tab-or-frame)
  :preface
  (defun my/close-tab-or-frame ()
    (interactive) (if (> (length (tab-bar-tabs)) 1)
                      (tab-close) (delete-frame))))

;; Transpose frame
(use-package transpose-frame
  :bind
  ("C-S-s" . rotate-frame-clockwise)
  ("C-S-r" . rotate-frame-anticlockwise)
  ("C-S-o" . other-window))

;; Recentf
(use-package recentf
  :init
  (setq recentf-auto-cleanup 'never)
  (setq recentf-max-saved-items nil)
  :config
  (recentf-mode t)
  (with-eval-after-load 'tramp
    (remove-hook 'tramp-cleanup-all-buffers-hook 'tramp-recentf-cleanup-all)
    (remove-hook 'tramp-cleanup-connection-hook 'tramp-recentf-cleanup-all)
    (remove-hook 'tramp-cleanup-all-connections-hook 'tramp-recentf-cleanup-all)))

;; Tramp
;; https://emacs.stackexchange.com/questions/26560/bookmarking-remote-directories-trampsudo#comment40572_26567
;; https://www.gnu.org/software/emacs/manual/html_node/tramp/Ad_002dhoc-multi_002dhops.html
;; https://coredumped.dev/2025/06/18/making-tramp-go-brrrr
(use-package tramp
  :custom
  (tramp-show-ad-hoc-proxies t)
  (tramp-completion-multi-hop-methods `(,tramp-docker-method ,tramp-podman-method))
  (remote-file-name-inhibit-locks t)
  (tramp-use-scp-direct-remote-copying t)
  (remote-file-name-inhibit-auto-save-visited t)
  (tramp-copy-size-limit (* 1024 1024)) ;; 1MB
  (tramp-verbose 2)
  (connection-local-set-profile-variables
   'remote-direct-async-process
   '((tramp-direct-async-process . t)))
  (connection-local-set-profiles
   '(:application tramp :protocol "scp")
   'remote-direct-async-process)
  (setq magit-tramp-pipe-stty-settings 'pty))
(with-eval-after-load 'tramp
  (add-to-list 'tramp-remote-path 'tramp-own-remote-path)
  (add-to-list 'tramp-remote-path "~/.local/bin"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Path
(use-package exec-path-from-shell
  :if (or (daemonp) (memq window-system '(mac ns x)))
  :config
  (exec-path-from-shell-initialize))

;;; Vterm
(use-package vterm
  :commands vterm
  :config
  (setq vterm-timer-delay 0.01)
  (setq vterm-shell "/bin/bash")
  (setq vterm-tramp-shells '(("ssh" "/bin/bash")
                             ("scp" login-shell)
                             ("docker" "/bin/bash")
                             ("podman" "/bin/bash"))))

;;; Multi-vterm
(use-package multi-vterm
  :preface
  (defun my/multi-vterm-local ()
    (interactive)
    (let ((default-directory "~/"))
      (multi-vterm)))
  :bind
  ("C-`" . multi-vterm-dedicated-toggle)
  ("C-S-v" . my/multi-vterm-local))

;; Podman
(use-package docker
  ;; :bind
  ;; ("C-c d" . docker)
  :custom
  (docker-command "podman"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Projectile
(use-package projectile
  :init
  (setq projectile-project-search-path '(("~/workspace/" . 10)))
  :config
  (projectile-mode t)
  (defun my/projectile-ivy-completing-read (prompt choices &optional initial-input)
    (ivy-read prompt choices
              :initial-input initial-input
              :caller 'my/projectile-ivy-completing-read))
  (setq projectile-completion-system #'my/projectile-ivy-completing-read)
  :bind-keymap
  ("C-x p" . projectile-command-map))

;; Which-key
;; https://github.com/justbur/emacs-which-key?tab=readme-ov-file#manual-activation
(use-package which-key
  :init
  (setq which-key-show-early-on-C-h t)
  (setq which-key-idle-delay 10000)
  (setq which-key-idle-secondary-delay 0.05)
  :config
  (which-key-mode t))

;; Company
(use-package company
  :hook
  (after-init . global-company-mode)
  (scheme-mode . (lambda () (company-mode -1)))
  (geiser-repl-mode . (lambda () (company-mode -1)))
  :custom
  (company-selection-wrap-around t)
  (company-tooltip-align-annotations t)
  (company-idle-delay 0.45)
  (company-minimum-prefix-length 3)
  (company-backends '(company-capf company-dabbrev))
  :bind
  (:map company-mode-map
        ("M-TAB" . company-complete)))

;; Avy
(use-package avy
  :config
  (avy-setup-default)
  :bind
  ("C-:" . avy-goto-line)
  ("C-c C-j" . avy-resume))

;; Ivy
(use-package ivy)

;; Counsel
(use-package counsel
  :config
  (setq counsel-search-engine 'google)
  :bind
  ("C-c S" . counsel-rg)
  ("C-S-g" . counsel-search)
  ("C-S-b" . counsel-switch-buffer)
  ("C-S-f" . counsel-find-file)
  ("C-x C-a" . counsel-recentf))

;; Ripgrep
(use-package rg
  :config
  (rg-enable-default-bindings))

;; Magit
(use-package magit
  :bind
  ("C-x g" . magit-dispatch)
  ("C-x G" . magit-file-dispatch))

(use-package diff-hl
  :config
  (global-diff-hl-mode)
  (setq diff-hl-show-staged-changes nil))

;; Dired-git-info
(use-package dired-git-info
  :config
  (setq dgi-auto-hide-details-p nil)
  (define-key dired-mode-map ")" 'dired-git-info-mode))

;; Dired-rsync
(use-package dired-rsync
  :bind (:map dired-mode-map
              ("C-c C-r" . dired-rsync)))

(use-package dired-rsync-transient
  :bind (:map dired-mode-map
              ("C-c C-x" . dired-rsync-transient)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package python
  :config
  (setq python-shell-interpreter "uv")
  (setq python-shell-interpreter-args "run python")
  (setq python-shell-prompt-detect-failure-warning nil)
  (defun my/python-shell-set-project-root ()
    (let ((root (project-root (project-current))))
      (when root
        (setq-local default-directory root))))
  (add-hook 'python-mode-hook 'my/python-shell-set-project-root))

;; ESS
(use-package ess
  :custom
  (ess-style 'RStudio)
  (ess-use-flymake nil)
  (ess-eval-visibly 'nowait)
  (ess-r-package-auto-activate nil)) ;; Fix hanging ESS process during lost connection

;; Ess-plot
(use-package ess-plot
  :vc (:url "https://github.com/DennieTeMolder/ess-plot" :rev :newest)
  :hook (ess-r-post-run . ess-plot-on-startup-h))

;; SICP
(use-package sicp)

;; Geiser-mit
(use-package geiser-mit)
;; Replace "~/.emacs.d/elpa/geiser-mit-20240909.1145/src/geiser/load.scm" with
;;
;; (declare (usual-integrations))
;;
;; (with-working-directory-pathname
;;     (directory-pathname (current-load-pathname))
;;   (lambda ()
;;     ;; Bypass compilation to avoid MIT Scheme 12.1 %record-ref error
;;     ;; (load "compile.scm")
;;     ;; (load-package-set "geiser" `())
;;
;;     ;; Load the source directly
;;     (load "emacs.scm")))
;;
;; (add-subsystem-identification! "Geiser" '(0 1))

;; Pdf-tools
;; https://stackoverflow.com/a/59017280
(use-package pdf-tools
  :magic ("%PDF" . pdf-view-mode) ;; Load pdf-tools when a PDF is opened
  :config
  (pdf-tools-install)
  (setq-default pdf-view-display-size 'fit-page)
  (add-to-list 'revert-without-query ".pdf"))

;; Dot
(use-package graphviz-dot-mode
  :config
  (setq graphviz-dot-indent-width 2)
  :hook
  (graphviz-dot-mode . flycheck-mode))

;; Citar
(use-package vertico)
(use-package citar
  :after org
  :custom
  (org-cite-global-bibliography '("~/workspace/notes/tej.bib"))
  (citar-notes-paths '("~/workspace/notes/org/citar"))
  (org-cite-insert-processor 'citar)
  (org-cite-follow-processor 'citar)
  (org-cite-activate-processor 'citar)
  (citar-bibliography org-cite-global-bibliography)
  (citar-select-multiple nil)
  (org-cite-csl-styles-dir "~/Zotero/styles")
  (org-cite-export-processors '((t . (csl "american-medical-association.csl"))))
  :bind
  ("C-c i p" . #'citar-open-files)
  ("C-c i l" . #'citar-open-links)
  ("C-c i n" . citar-open-notes)
  ("C-c i z" . #'citar-open-entry-in-zotero)
  :hook
  (LaTeX-mode . citar-capf-setup)
  (org-mode . citar-capf-setup))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Org-mac-link
(use-package org-mac-link
  :bind
  ("C-c g" . org-mac-link-get-link))

;; Org
;; https://github.com/erikriverson/org-mode-R-tutorial/blob/master/org-mode-R-tutorial.org#inserting-r-graphical-output
;; https://stackoverflow.com/a/75086516
;; https://yiming.dev/blog/2018/03/02/my-org-refile-workflow/
;; https://stackoverflow.com/a/63943091
;; https://karthinks.com/software/scaling-latex-previews-in-emacs/
;; https://orgmode.org/worg/org-faq.html#list-item-as-todo
;; https://emacs.stackexchange.com/a/62724
(use-package org
  :preface
  (defun my/org-targets ()
    "Dynamic list of org files for refile and agenda."
    (delete-dups
     (mapcar #'file-truename
             (append (directory-files-recursively org-directory "\\.org$")
                     ;; (directory-files-recursively default-directory "\\.org$")
                     (seq-keep #'buffer-file-name
                               (seq-filter (lambda (buf)
                                             (let ((file (buffer-file-name buf)))
                                               (and file (string-suffix-p ".org" file))))
                                           (buffer-list)))))))
  (defun my/org-agenda ()
    (interactive)
    (setq org-agenda-files (my/org-targets))
    (org-agenda))
  (defun my/text-scale-adjust-latex-previews ()
    "Adjust the size of latex preview fragments when changing the buffer's text scale."
    (pcase major-mode
      ('latex-mode
       (dolist (ov (overlays-in (point-min) (point-max)))
         (if (eq (overlay-get ov 'category)
                 'preview-overlay)
             (my/text-scale--resize-fragment ov))))
      ('org-mode
       (dolist (ov (overlays-in (point-min) (point-max)))
         (my/text-scale--resize-fragment ov)))))
  (defun my/text-scale--resize-fragment (ov)
    (overlay-put
     ov 'display
     (cons 'image
           (plist-put
            (cdr (overlay-get ov 'display))
            :scale (+ 1.0 (* 0.25 text-scale-mode-amount))))))
  (defun my/babel-remote-file-insert (orig-proc &rest args)
    (apply orig-proc
           (cons (concat (file-remote-p default-directory)
                         (car args))
                 (cdr args))))
  ;; Sorry
  (defun my/org-file-contents (file &optional noerror nocache)
    "Return the contents of FILE, as a string.

FILE can be a file name or URL.

If FILE is a URL, download the contents.  If the URL contents are
already cached in the `org--file-cache' hash table, the download step
is skipped.

If NOERROR is non-nil, ignore the error when unable to read the FILE
from file or URL, and return nil.

If NOCACHE is non-nil, do a fresh fetch of FILE even if cached version
is available.  This option applies only if FILE is a URL."
  (let* ((is-url (org-url-p file))
         (is-remote (condition-case nil
                        (file-remote-p file)
                      ;; In case of error, be safe.
                      ;; See bug#68976.
                      (t t)))
         (cache (and is-url
                     (not nocache)
                     (gethash file org--file-cache))))
    (cond
     (cache)
     (is-url ;; Changed
      (if (org--should-fetch-remote-resource-p file)
          (condition-case error
              (with-current-buffer (url-retrieve-synchronously file)
                (goto-char (point-min))
                ;; Move point to after the url-retrieve header.
                (search-forward "\n\n" nil :move)
                ;; Search for the success code only in the url-retrieve header.
                (if (save-excursion
                      (re-search-backward "HTTP.*\\s-+200\\s-OK" nil :noerror))
                    ;; Update the cache `org--file-cache' and return contents.
                    (puthash file
                             (buffer-substring-no-properties (point) (point-max))
                             org--file-cache)
                  (funcall (if noerror #'message #'user-error)
                           "Unable to fetch file from %S"
                           file)
                  nil))
            (error (if noerror
                       (message "Org couldn't download \"%s\": %s %S" file (car error) (cdr error))
                     (signal (car error) (cdr error)))))
        (funcall (if noerror #'message #'user-error)
                 "The remote resource %S is considered unsafe, and will not be downloaded."
                 file)))
     (t
      (with-temp-buffer
        (condition-case nil
	    (progn
	      (insert-file-contents file)
	      (buffer-string))
	  (file-error
           (funcall (if noerror #'message #'user-error)
		    "Unable to read file %S"
		    file)
	         nil)))))))
  ;; Treat roam nodes as tags
  (defun my/roam-to-tag (id)
    (string-replace "-" "_" id))
  (defun my/tag-to-roam (tag)
    (string-replace "_" "-" tag))
  (defun my/org-element--headline-parse-title (headline raw-secondary-p)
    "Resolve title properties of HEADLINE for side effect.
  When RAW-SECONDARY-P is non-nil, headline's title will not be
  parsed as a secondary string, but as a plain string instead.

  Throw `:org-element-deferred-retry' signal at the end."
    (with-current-buffer (org-element-property :buffer headline)
      (org-with-point-at (org-element-begin headline)
        (let* ((begin (point))
               (true-level (prog1 (skip-chars-forward "*")
                             (skip-chars-forward " \t")))
  	           (level (org-reduced-level true-level))
  	           (todo (and org-todo-regexp
  		                    (let (case-fold-search) (looking-at (concat org-todo-regexp "\\(?: \\|$\\)")))
  		                    (progn (goto-char (match-end 0))
  			                         (skip-chars-forward " \t")
                                 (org-element--get-cached-string (match-string-no-properties 1)))))
  	           (todo-type
  	            (and todo (if (member todo org-done-keywords) 'done 'todo)))
  	           (priority (and (looking-at "\\[#.\\][ \t]*")
  			                      (progn (goto-char (match-end 0))
  				                           (aref (match-string 0) 2))))
  	           (commentedp
  	            (and (let ((case-fold-search nil))
                       (looking-at org-element--headline-comment-re))
                     (prog1 t
  		                 (goto-char (match-end 0))
                       (skip-chars-forward " \t"))))
  	           (title-start (point))
               (roam-tags ;; Changed
                (let* ((title (buffer-substring-no-properties title-start (line-end-position)))
                       (tmp '()))
                  (while (string-match "\\[\\[id:\\([^]]+\\)\\]\\[[^]]+\\]\\]" title)
                    (push (my/roam-to-tag (match-string 1 title)) tmp)
                    (setq title (replace-match "" nil nil title)))
                  tmp))
  	           (tags (when (re-search-forward
  			                    "\\(:[[:alnum:]_@#%:]+:\\)[ \t]*$"
  			                    (line-end-position)
  			                    'move)
  		                 (goto-char (match-beginning 0))
                       (mapcar #'org-element--get-cached-string
  		                         (org-split-string (match-string-no-properties 1) ":"))))
  	           (title-end (point))
  	           (raw-value
                (org-element-deferred-create
                 t #'org-element--headline-raw-value
                 (- title-start begin) (- title-end begin))))
          (org-element-put-property headline :raw-value raw-value)
          (org-element-put-property headline :level level)
          (org-element-put-property headline :priority priority)
          (org-element-put-property headline :tags (delete-dups (append tags roam-tags)))
          (org-element-put-property headline :todo-keyword todo)
          (org-element-put-property headline :todo-type todo-type)
          (org-element-put-property
           headline :footnote-section-p org-element--headline-footnote-section-p)
          (org-element-put-property headline :archivedp org-element--headline-archivedp)
          (org-element-put-property headline :commentedp commentedp)
  	      (org-element-put-property
  	       headline :title
  	       (if raw-secondary-p
               org-element--headline-raw-value
  	         (org-element--parse-objects
  	          (progn (goto-char title-start)
  		               (skip-chars-forward " \t")
  		               (point))
  	          (progn (goto-char title-end)
  		               (skip-chars-backward " \t")
  		               (point))
  	          nil
  	          (org-element-restriction
               (org-element-type headline))
  	          headline))))))
    (throw :org-element-deferred-retry nil))
  :bind
  ("C-c l" . org-store-link)
  ("C-c a" . my/org-agenda)
  ("C-c c" . org-capture)
  :hook
  (org-babel-after-execute . org-display-inline-images)
  (org-mode . org-display-inline-images)
  (text-scale-mode-hook . my/text-scale-adjust-latex-previews)
  :config
  (modify-syntax-entry ?< "." org-mode-syntax-table)
  (modify-syntax-entry ?> "." org-mode-syntax-table)
  ;; Export & PDF
  (add-to-list 'org-file-apps '("\\.pdf\\'" . emacs))
  (advice-add 'org-file-contents :override #'my/org-file-contents)
  (advice-add 'org-element--headline-parse-title :override #'my/org-element--headline-parse-title)
  ;; Paths & Files
  (setq org-directory "~/workspace/notes/org/")
  (setq org-default-notes-file (concat org-directory "easy.org"))
  (setq org-agenda-files (list org-directory))
  (setq org-agenda-include-inactive-timestamps t)
  (setf (cdr (assoc 'file org-link-frame-setup)) #'find-file)
  ;; Babel
  (setq org-confirm-babel-evaluate nil)
  (setq org-src-window-setup 'current-window)
  (setq org-startup-with-inline-images t)
  (setq org-display-remote-inline-images t)
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((R . t)
     (shell . t)
     (scheme . t)
     (python . t)
     (latex . t)
     (dot . t)))
  (setq org-babel-default-header-args:elisp
        '((:lexical yes)))
  (add-to-list 'org-src-lang-modes '("dot" . graphviz-dot))
  (defun my/org-babel-dot-args (appearance)
    (let ((cmdline (format "-Tpdf %s \
                            -Gmargin=0 -Gbgcolor=transparent -Nstyle=filled \
                            -Gfontname=Helvetica -Efontname=Helvetica -Nfontname=Helvetica \
                            -Gfontsize=24        -Efontsize=16        -Nfontsize=16"
                           (if (string= appearance 'light)
                               "-Efontcolor=black -Nfontcolor=black -Nfillcolor=white"
                             "-Gfontcolor=white -Efontcolor=white -Nfontcolor=white -Nfillcolor=transparent \
                              -Gcolor=white     -Ecolor=white     -Ncolor=white"))))
      (setq org-babel-default-header-args:dot
            `((:results . "file")
	            (:exports . "results")
              (:file . (lambda () (make-temp-file "/tmp/dot-" nil ".pdf"))) ;; https://stackoverflow.com/q/8327939
	            (:cmdline . ,cmdline)))))
  (my/org-babel-dot-args 'dark) ;; Want dark mode all the time :)
  ;; (my/org-babel-dot-args ns-system-appearance)
  ;; (add-hook 'ns-system-appearance-change-functions #'my/org-babel-dot-args)
  (setq org-babel-default-header-args:R
        '((:file . (lambda () (make-temp-file "/tmp/R-" nil ".pdf")))))
  (advice-add #'org--create-inline-image :around #'my/babel-remote-file-insert)
  ;; Latex
  (setq org-export-with-toc nil
        org-export-with-sub-superscripts '{})
  (setq org-latex-default-table-environment "longtable")
  (setq org-latex-hyperref-template "\\hypersetup{colorlinks=true, citecolor=blue}")
  (setq org-latex-compiler "lualatex")
  (setq org-preview-latex-default-process 'dvisvgm)
  (setenv "LIBGS" "/opt/homebrew/lib/libgs.dylib") ;; Ghostscript dylib
  (setq org-preview-latex-image-directory org-babel-temporary-directory)
  (setq org-preview-latex-process-alist
        (cons '(dvisvgm
                :programs ("lualatex" "dvisvgm")
                :description "dvi > svg"
                :message "rendering SVGs via lualatex..."
                :image-input-type "dvi"
                :image-output-type "svg"
                :latex-compiler
                ("lualatex -interaction nonstopmode -output-format=dvi -output-directory=%o \"\\def\\pgfsysdriver{pgfsys-dvisvgm.def}\\input{%f}\"")
                :image-converter
                ("dvisvgm %f --no-fonts --zoom=2 --exact-bbox --output=%O"))
              (assq-delete-all 'dvisvgm org-preview-latex-process-alist)))
  ;; Refile & Navigation
  (setq org-goto-auto-isearch nil)
  (setq org-refile-targets '((my/org-targets :maxlevel . 5)))
  (setq org-refile-use-outline-path t)
  (setq org-use-property-inheritance t)
  (setq org-id-link-consider-parent-id t)
  (setq org-outline-path-complete-in-steps nil)
  ;; TODOs
  (require 'org-inlinetask)
  (setq org-deadline-warning-days 0)
  (setq org-use-fast-todo-selection 'expert)
  (setq org-hierarchical-todo-statistics nil)
  (setq org-todo-keywords '((sequence "TODO(t)" "WAIT(w)" "INPR(i)" "READ(r)" "CANC(c)" "|" "DONE(d)")))
  (setq org-todo-keyword-faces '(("READ" . "deep sky blue")
                                 ("CANC" . "grey")
                                 ("INPR" . "orange")
                                 ("WAIT" . "red")))
  (defun my/org-deadline-inpr (orig-proc &rest args)
    (let ((arg (car args)))
      (save-excursion
        (unless (and arg (equal arg '(4)))
          (org-todo "INPR"))))
    (apply orig-proc args))
  (advice-add 'org-deadline :around #'my/org-deadline-inpr)
  (defun my/org-deadline-remove ()
    (when (member org-state '("TODO" "READ" "CANC"))
      (org-deadline '(4))))
  (add-hook 'org-after-todo-state-change-hook 'my/org-deadline-remove)
  ;; Capture
  (setq org-capture-templates
        '(("t" "Task" entry (file+headline "" "Tasks") "* TODO %?\n  %u\n  %a")
          ("c" "Capture" entry (file org-default-notes-file) "* %^{Topic} %U %^G\n%?\nlink: %a\n")
          ("n" "Note" entry (file org-default-notes-file) "* %^{Topic} %U %^G\n%?\n"))))

;; Ox-latex
;; https://emacs.stackexchange.com/a/66596
(use-package ox-latex
  :ensure nil
  :config
  (setq org-latex-packages-alist
        '(("" "tikz" t)
          ("" "tikz-cd" t)))
  (add-to-list 'org-latex-classes
               '("tej"
                 "\\documentclass[11pt]{article}
                  \\usepackage[margin=1in]{geometry}
                  \\usepackage{microtype}
                  \\usepackage{parskip}
                  \\usepackage{fontspec}
                  \\usepackage{mathtools}
                  \\usepackage{unicode-math}
                  \\usepackage{tikz}
                  \\usepackage{tikz-cd}
                  \\usepackage{xcolor}
                  % Table Support Packages
                  \\usepackage{booktabs}
                  \\usepackage{longtable}
                  \\usepackage{array}
                  \\usepackage{multirow}
                  \\usepackage{wrapfig}
                  \\usepackage{float}
                  \\usepackage{colortbl}
                  \\usepackage{pdflscape}
                  \\usepackage{tabu}
                  \\usepackage{threeparttable}
                  \\usepackage{threeparttablex}
                  \\usepackage[normalem]{ulem}
                  \\usepackage{makecell}
                  \\usepackage{caption}
                  \\definecolor{darkgrey}{RGB}{50,50,50}
                  \\color{darkgrey}
                  \\setmainfont[BoldFont={Libertinus Serif Bold}, ItalicFont={Libertinus Serif Italic}]{Libertinus Serif}
                  \\setmathfont{Libertinus Math}"
                 ("\\section{%s}" . "\\section*{%s}")
                 ("\\subsection{%s}" . "\\subsection*{%s}")
                 ("\\subsubsection{%s}" . "\\subsubsection*{%s}"))))

;; Org-ql
(use-package org-ql)

;; Org-inline-pdf
(use-package org-inline-pdf
  :after org
  :preface
  (defun my/org-inline-pdf--make-preview-for-pdf (original-org--create-inline-image &rest arguments)
    "Make a SVG preview when the inline image is a PDF.
This function is to be used as an `around' advice to
`org--create-inline-image'.  The original function is passed in
ORIGINAL-ORG--CREATE-INLINE-IMAGE and arguments in ARGUMENTS."
    (let ((file (car arguments))
	        (page-num (org-inline-pdf--get-page-number)))
      (apply original-org--create-inline-image
	           (cons
	            (if (member (file-name-extension file) '("pdf" "PDF"))
		              (let ((svg (expand-file-name
			                        (concat "org-inline-pdf-"
				                              (md5 (format "%s:%s" file page-num)) ".svg") ;; Changed (suffix)
			                        (org-inline-pdf-cache-directory))))
		                (when (or (not (file-exists-p svg))
			                        (time-less-p (nth 5 (file-attributes svg))
					                                 (nth 5 (file-attributes file))))
		                  (process-file org-inline-pdf-make-preview-program ;; Changed (TRAMP)
				                            nil nil nil file svg page-num))
		                svg)
	              file)
	            (cdr arguments)))))
  :hook
  (org-mode-hook . org-inline-pdf-mode)
  :config
  (advice-add 'org-inline-pdf--make-preview-for-pdf :override #'my/org-inline-pdf--make-preview-for-pdf)
  (setq org-inline-pdf-cache-directory "/tmp"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Custom
(setq custom-file "~/.emacs.d/custom.el")
(when (file-exists-p custom-file)
  (load custom-file))
(put 'help-fns-edit-variable 'disabled nil)
