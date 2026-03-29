;; -*- lexical-binding: t -*-
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; https://github.com/xenodium/dotsies/blob/2ec51825c98f2fd20fbb085a5126beb894c307f0/emacs/early-init.el
(setq idle-update-delay 1.0)

;; Must be set early to avoid title bar temporarily appearing
;; in a different color.
(if (eq system-type 'darwin)
    (progn
      (setq mac-allow-anti-aliasing 1)
      ;; https://github.com/d12frosted/homebrew-emacs-plus/tree/master/community/patches/frame-transparency
      ;; (progn
      ;;   (set-frame-parameter nil 'ns-alpha-elements '(ns-alpha-all))
      ;;   (set-frame-parameter nil 'alpha-background 1.0)
      ;;   (set-frame-parameter nil 'ns-background-blur 30))
      ;; Needed so hex colors are rendered accurately on macOS.
      (setq ns-use-srgb-colorspace nil)
      (setq default-frame-alist
            '((background-color . "#212121")
              (ns-transparent-titlebar . t)
              (internal-border-width . 0))))
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
(add-to-list 'default-frame-alist '(font . "Roboto Mono 14"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; https://github.com/rougier/elegant-emacs/blob/d901cf9456b030707ee39ce7cc35e9b988040cf0/sanity.el#L18
(setq gc-cons-threshold (* 100 1024 1024))
(setq inhibit-startup-screen t)
(setq inhibit-startup-echo-area-message t)
(setq inhibit-startup-message t)
(setq initial-scratch-message nil)
(defun display-startup-echo-area-message ())
(cd "~/workspace/notes/org/")
