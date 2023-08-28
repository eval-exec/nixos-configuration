;;; package --- Summary
;;; Commentary:
;;; early init
;;; Code:

(menu-bar-mode t)

(tool-bar-mode -1)
(scroll-bar-mode -1)

(setq
  native-comp-async-jobs-number 10
  redisplay-skip-fontification-on-input t
  fast-but-imprecise-scrolling t
 )
;; Disable package.el in favor of straight.el
(setq package-enable-at-startup nil)

(setq-default native-comp-async-report-warnings-errors nil)

(setq inhibit-splash-screen t)
(setq inhibit-startup-message t)
(setq gc-cons-threshold 10000000000
      gc-cons-percentage 0.9)

(add-to-list 'initial-frame-alist '(maximized . maximized))


(set-frame-parameter nil 'alpha-background 100)
(set-frame-parameter nil 'alpha 1.0)

(set-face-attribute 'default nil  :family
					;; "Hack Nerd Font Mono"
;; "AnonymicePro Nerd Font Mono"
					"UbuntuMono Nerd Font Mono"
					:height 110 :weight 'normal)

(provide 'emacs-early-init)

;;; emacs-early-init.el ends here
