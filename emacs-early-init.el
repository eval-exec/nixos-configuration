;;; package --- Summary
;;; Commentary:
;;; early init
;;; Code:

(menu-bar-mode -1)

(tool-bar-mode -1)
(scroll-bar-mode -1)

(setq
  native-comp-async-jobs-number 10
  redisplay-skip-fontification-on-input t
  fast-but-imprecise-scrolling t
 )
;; Disable package.el in favor of straight.el
(setq package-enable-at-startup nil)

(setq native-comp-async-report-warnings-errors nil)

(setq inhibit-splash-screen t)
(setq inhibit-startup-message t)
(setq gc-cons-threshold 10000000000
      gc-cons-percentage 0.9)

(add-to-list 'initial-frame-alist '(fullscreen . maximized))

(set-face-attribute 'default nil  :family "Noto Sans Mono" :height 80 :weight 'normal)
