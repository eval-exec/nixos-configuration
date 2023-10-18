;;; package --- Summary
;;; Commentary:
;;; early init
;;; Code:

(setq-default use-package-enable-imenu-support t)

(menu-bar-mode -1)

(tool-bar-mode -1)
(scroll-bar-mode -1)

(setq
 native-comp-async-jobs-number 20
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

(add-to-list 'initial-frame-alist '(fullscreen . maximized))

(setq initial-major-mode 'fundamental-mode)



(set-frame-parameter nil 'alpha-background 100)
(set-frame-parameter nil 'alpha 1.0)

(setq-default window-resize-pixelwise t)
(setq-default frame-resize-pixelwise t)

(set-face-attribute 'default nil  :family "Jetbrains Mono" :weight 'normal :height 120)
(set-face-attribute 'fixed-pitch nil :family "Jetbrains Mono")
(set-face-attribute 'variable-pitch nil :family "Sarasa Gothic SC")

;; 🧬
;; it’s 中文测试`''`'《》，。
;;- [X] sub task two
;;- [ ] sub task three
;; '🂩
;; ->
(setq use-default-font-for-symbols nil)
;; (set-fontset-font t 'unicode "Sarasa Term SC Nerd")
;; (set-fontset-font t 'unicode "Symbols Nerd Font Mono" nil 'append)
;; (set-fontset-font t 'playing-cards (font-spec :script 'playing-cards))
;; (set-fontset-font t 'cyrillic "Sarasa Term SC Nerd")
(set-fontset-font t 'han "Noto Sans CJK SC") ;; 关门，直接
(set-fontset-font t 'cjk-misc "Noto Sans SC") ;;？？？，，， 柴 鱼 の c a l l i n g  —  幸 子 小 姐 (HD) [OSEFETzFgfo].mp3

(set-fontset-font t 'symbol "Noto Sans Symbols")
(set-fontset-font t 'emoji "Noto Color Emoji")
;; (set-fontset-font t 'playing-cards "Noto Sans Symbols" nil 'append)
;; (set-fontset-font t 'playing-cards "Noto Sans Symbols 2" nil 'append)

;; (setq face-font-rescale-alist '(
;; 								("Noto Color Emoji" . 1.0)
;; 								;; ("Symbols Nerd Font Mono" . 1.0)
;; 								))


(setq left-margin-width 1 right-margin-width 0)
(fringe-mode '(16 . 0))
(set-face-attribute 'fringe nil :background "black")
(set-background-color "black")

(provide 'emacs-early-init)

;;; emacs-early-init.el ends here
