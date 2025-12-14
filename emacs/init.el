;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; https://www.gnu.org/software/emacs/manual/html_node/emacs/Emacs-Server.html
(server-start)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; https://emacs.stackexchange.com/questions/26560/bookmarking-remote-directories-trampsudo#comment40572_26567
;; https://www.gnu.org/software/emacs/manual/html_node/tramp/Ad_002dhoc-multi_002dhops.html
(require 'tramp)
(customize-set-variable 'tramp-show-ad-hoc-proxies t)
(customize-set-variable 'tramp-completion-multi-hop-methods
			`(,tramp-docker-method ,tramp-podman-method))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; https://www.r-bloggers.com/2022/12/using-emacs-for-r/
;; Enable package system and repositories
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

;; https://github.com/purcell/exec-path-from-shell?tab=readme-ov-file#usage
(use-package exec-path-from-shell
  :ensure t)
(when (daemonp)
  (exec-path-from-shell-initialize))

;; R mode (ESS)
(use-package ess
  :ensure t)
(setq ess-style 'RStudio)
(setq ess-use-flymake nil)
(setq ess-eval-visibly 'nowait)
(setq ess-r-package-auto-activate nil) ;; Fix hanging ESS process during lost connection

;; Autocomplete
(use-package company
  :config
  (add-hook 'after-init-hook #'global-company-mode))
(setq company-selection-wrap-around t
      company-tooltip-align-annotations t
      company-idle-delay 0.45
      company-minimum-prefix-length 3
      company-tooltip-limit 10)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Vterm
(use-package vterm
  :ensure t)

;; https://github.com/suonlight/multi-vterm
(use-package multi-vterm
  :ensure t)

;; Helm
(use-package helm
  :ensure t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; New iTerm
(defun iterm-new-window ()
  (interactive)
  (let ((cmd "osascript -e 'tell application \"iTerm\" to create window with default profile'"))
    (shell-command cmd)))

;; Magit
(use-package magit
  :ensure t)
(use-package git-gutter
  :ensure t)
;; If you enable global minor mode
(global-git-gutter-mode t)
(global-set-key (kbd "C-x C-g") 'git-gutter)
;; Jump to next/previous hunk
(global-set-key (kbd "M-p") 'git-gutter:previous-hunk)
(global-set-key (kbd "M-n") 'git-gutter:next-hunk)
;; Stage current hunk
(global-set-key (kbd "C-x v s") 'git-gutter:stage-hunk)
;; Revert current hunk
(global-set-key (kbd "C-x v r") 'git-gutter:revert-hunk)

;; Pdf-tools
(use-package pdf-tools
  :ensure t
  :config
  (pdf-tools-install))

;; https://stackoverflow.com/a/59017280
(setq revert-without-query '(".pdf"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; org-mac-link
(use-package org-mac-link
  :ensure t)

;; Org mode pandoc
(use-package ox-pandoc
  :ensure t)

;; Org-babel
(org-babel-do-load-languages
 'org-babel-load-languages
 '((R . t)
   (python . t)
   (dot . t)))

(setq org-confirm-babel-evaluate nil)

;; Agenda and refile
(defun tej/org-pwd-files ()
  "List all *.org files in current working directory"
  (directory-files default-directory t "\\.org$")) ; [directory &optional full match] nosort count
;; https://yiming.dev/blog/2018/03/02/my-org-refile-workflow/
(defun tej/org-buffers ()
  "Return the list of `.org` files currently opened in Emacs."
  (delq nil
        (mapcar (lambda (x)
                  (let ((file (buffer-file-name x)))
                    (if (and file
			     (string-match "\\.org$" file))
			file)))
                (buffer-list))))
(defun tej/org-targets ()
  "Return org repository files, open org buffers, and pwd org files (includes current buffer)"
  (delete-dups
   (append (directory-files org-directory t "\\.org$") ; org repo files
	   (tej/org-buffers)                              ; open org buffers
	   (tej/org-pwd-files))))                         ; pwd org files (includes current buffer)
;; https://stackoverflow.com/a/63943091
(defun tej/org-agenda ()
  (interactive)
  (let ((org-agenda-files (tej/org-targets)))
    (org-agenda)))

;; Set params
(setq org-agenda-files (list org-directory))
(setq org-refile-targets '((tej/org-targets :maxlevel . 5)))
(setq org-outline-path-complete-in-steps nil)         ; Refile in a single go
(setq org-refile-use-outline-path t)                  ; Show full paths for refiling

;; Org key mappings
(global-set-key (kbd "C-c l") #'org-store-link)
;; (global-set-key (kbd "C-c a") #'org-agenda)
(global-set-key (kbd "C-c a") #'tej/org-agenda)
(global-set-key (kbd "C-c c") #'org-capture)
(global-set-key (kbd "C-c g") #'org-mac-link-get-link)

;; https://github.com/erikriverson/org-mode-R-tutorial/blob/master/org-mode-R-tutorial.org#inserting-r-graphical-output
(add-hook 'org-babel-after-execute-hook 'org-display-inline-images)
(add-hook 'org-mode-hook 'org-display-inline-images)
;; https://stackoverflow.com/a/75086516
(setq org-display-remote-inline-images t)

;; info:org#Motion
(setq org-goto-auto-isearch nil)

;; (setq org-format-latex-options (plist-put org-format-latex-options :scale 1.5))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; https://github.com/doomemacs/themes?tab=readme-ov-file#manually--use-package
(use-package doom-themes
  :ensure t
  :custom
  ;; Global settings (defaults)
  (doom-themes-enable-bold t)    ; if nil, bold is universally disabled
  (doom-themes-enable-italic t)) ; if nil, italics is universally disabled

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package dimmer
  :ensure t)
(dimmer-mode t)
(setq dimmer-fraction 0.4)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; https://github.com/d12frosted/homebrew-emacs-plus?tab=readme-ov-file#system-appearance-changevsl
(defun tej/apply-theme (appearance)
  (mapc #'disable-theme custom-enabled-themes)
  (pcase appearance
    ('light (load-theme 'doom-wilmersdorf t))
    ('dark  (load-theme 'doom-moonlight t))
    (_      (load-theme 'doom-moonlight t))))
;; Apply to new emacsclient frames
(defun tej/apply-theme-to-frame (frame)
  (with-selected-frame frame
    (tej/apply-theme ns-system-appearance)))
;; Apply
(add-hook 'ns-system-appearance-change-functions #'tej/apply-theme)
(add-hook 'after-make-frame-functions #'tej/apply-theme-to-frame)
(when (daemonp)
  (add-hook 'after-init-hook
            (lambda ()
              (when (display-graphic-p)
                (tej/apply-theme ns-system-appearance)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Mouse mode (https://unix.stackexchange.com/a/406519)
(xterm-mouse-mode 1)

;; Enable column numbers
(setq column-number-mode t)
(add-hook 'prog-mode-hook 'display-line-numbers-mode)
(add-hook 'org-mode-hook 'display-line-numbers-mode)

;; https://www.gnu.org/software/emacs/manual/html_node/emacs/General-VC-Options.html
(setq vc-follow-symlinks t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; https://systemcrafters.net/emacs-tips/keeping-folders-clean/
;; Backup files
(setq make-backup-files nil)

;; Auto save files
(make-directory (expand-file-name "tmp/auto-saves/" user-emacs-directory) t)
(setq auto-save-list-file-prefix (expand-file-name "tmp/auto-saves/sessions/" user-emacs-directory)
      auto-save-file-name-transforms `((".*" ,(expand-file-name "tmp/auto-saves/" user-emacs-directory) t)))

;; Lock files
(setq create-lockfiles nil)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Custom
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-use-property-inheritance t)
 '(package-selected-packages
   '(company dimmer doom-themes drag-stuff ess exec-path-from-shell
	     git-gutter helm htmlize magit markdown-mode multi-vterm
	     org-mac-link ox-pandoc pdf-tools sicp ssh
	     use-package-chords use-package-hydra)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(dolist (key '("<C-fn-left>" "<C-fn-right>" "<C-fn-up>" "<C-fn-down>"))
  (global-unset-key (kbd key)))
