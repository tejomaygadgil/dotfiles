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
(when (daemonp)
  (exec-path-from-shell-initialize))

;; R mode (ESS)
(use-package ess)

(setq ess-style 'RStudio)

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

;; Magit
(use-package magit
  :ensure t)

;; Pdf-tools
(use-package pdf-tools
  :ensure t
  :config
  (pdf-tools-install))

;; Org mode pandoc
(use-package ox-pandoc
  :ensure t)

;; Org-babel
(org-babel-do-load-languages
 'org-babel-load-languages
 '((R . t)))

(setq org-confirm-babel-evaluate nil)

;; https://github.com/erikriverson/org-mode-R-tutorial/blob/master/org-mode-R-tutorial.org#inserting-r-graphical-output
(add-hook 'org-babel-after-execute-hook 'org-display-inline-images)
(add-hook 'org-mode-hook 'org-display-inline-images)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; https://github.com/doomemacs/themes?tab=readme-ov-file#manually--use-package
(use-package doom-themes
  :ensure t
  :custom
  ;; Global settings (defaults)
  (doom-themes-enable-bold t)    ; if nil, bold is universally disabled
  (doom-themes-enable-italic t)) ; if nil, italics is universally disabled

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; https://github.com/d12frosted/homebrew-emacs-plus?tab=readme-ov-file#system-appearance-changevsl
(defun my/apply-theme (appearance)
  (load-theme 'doom-moonlight t)
  "Load theme, taking current system APPEARANCE into consideration."
  (mapc #'disable-theme custom-enabled-themes)
  (pcase appearance
    ('light (load-theme 'doom-wilmersdorf t))
    ('dark  (load-theme 'doom-moonlight t))))
(add-hook 'ns-system-appearance-change-functions #'my/apply-theme)

;; Apply to new emacsclient frames
(defun my/apply-theme-to-frame (frame)
  (with-selected-frame frame
    (my/apply-theme ns-system-appearance)))

(add-hook 'after-make-frame-functions #'my/apply-theme-to-frame)

(when (daemonp)
  (add-hook 'after-init-hook
            (lambda ()
              (when (display-graphic-p)
                (my/apply-theme ns-system-appearance)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Mouse mode (https://unix.stackexchange.com/a/406519)
(xterm-mouse-mode 1)

;; Enable column numbers
(setq column-number-mode t)
(add-hook 'prog-mode-hook 'display-line-numbers-mode)

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
 '(custom-safe-themes
   '("8d3ef5ff6273f2a552152c7febc40eabca26bae05bd12bc85062e2dc224cde9a"
     "1f292969fc19ba45fbc6542ed54e58ab5ad3dbe41b70d8cb2d1f85c22d07e518"
     "e8bd9bbf6506afca133125b0be48b1f033b1c8647c628652ab7a2fe065c10ef0"
     "d97ac0baa0b67be4f7523795621ea5096939a47e8b46378f79e78846e0e4ad3d"
     "aec7b55f2a13307a55517fdf08438863d694550565dee23181d2ebd973ebd6b8"
     "4d5d11bfef87416d85673947e3ca3d3d5d985ad57b02a7bb2e32beaf785a100e"
     "7ec8fd456c0c117c99e3a3b16aaf09ed3fb91879f6601b1ea0eeaee9c6def5d9"
     default))
 '(package-selected-packages
   '(company cond-let doom-themes drag-stuff ess exec-path-from-shell
	     helm llama magit markdown-mode multi-vterm ox-pandoc
	     ox-word pdf-tools use-package-chords use-package-hydra
	     vterm with-editor)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(dolist (key '("<C-fn-left>" "<C-fn-right>" "<C-fn-up>" "<C-fn-down>"))
  (global-unset-key (kbd key)))
