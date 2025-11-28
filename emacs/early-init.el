;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; https://github.com/xenodium/dotsies/blob/2ec51825c98f2fd20fbb085a5126beb894c307f0/emacs/early-init.el
(setq idle-update-delay 1.0)

;; Must be set early to avoid title bar temporarily appearing
;; in a different color.
(if (eq system-type 'darwin)
    (progn
      ;; Needed so hex colors are rendered accurately on macOS.
      (setq ns-use-srgb-colorspace nil)
      (setq default-frame-alist
            '((background-color . "#212121")
              (ns-transparent-titlebar . t)
              (ns-appearance . dark))))
  (setq default-frame-alist '((background-color . "#212121"))))

;; No scrollbar by default.
(when (fboundp 'scroll-bar-mode)
  (scroll-bar-mode -1))

;; No nenubar by default.
(when (fboundp 'menu-bar-mode)
  (menu-bar-mode -1))

;; No toolbar by default.
(when (fboundp 'tool-bar-mode)
  (tool-bar-mode -1))

;; No tooltip by default.
(when (fboundp 'tooltip-mode)
  (tooltip-mode -1))

;; No Alarms by default.
(setq ring-bell-function 'ignore)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Set font
(add-to-list 'default-frame-alist '(font . "FiraMono Nerd Font Mono-14"))
(setq mac-allow-anti-aliasing 2)
