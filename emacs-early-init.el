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
(setq gc-cons-threshold 10000000000000
      gc-cons-percentage 0.99)

(add-to-list 'initial-frame-alist '(fullscreen . maximized))

(setq initial-major-mode 'fundamental-mode)



(set-frame-parameter nil 'alpha-background 100)
(set-frame-parameter nil 'alpha 1.0)

(setq-default window-resize-pixelwise t)
(setq-default frame-resize-pixelwise t)

;; 🧬
;; it’s 中文测试`''`'《》，。
;;- [X] sub task two
;;- [ ] sub task three
;; '🂩
;; ->
;; "IosevkaTerm Nerd Font"
;; 关门，直接
;;？？？，，， 柴 鱼 の c a l l i n g  —  幸 子 小 姐 (HD) [OSEFETzFgfo].mp3

(add-hook 'after-init-hook
		  '(lambda()
			 (setq use-default-font-for-symbols nil)
			 (set-face-attribute 'default nil  :family "Iosevka" :height 100)
			 (set-face-attribute 'fixed-pitch nil :family "Iosevka")
			 (set-face-attribute 'variable-pitch nil :family "Iosevka")
			 (set-face-attribute 'nobreak-space nil :underline nil)


			 (set-fontset-font t 'unicode "Sarasa Term SC Nerd")
			 (set-fontset-font t 'cyrillic "Sarasa Term SC Nerd")
			 (set-fontset-font t 'symbol "Iosevka")
			 (set-fontset-font t 'symbol "Symbols Nerd Font Mono" nil 'append)
			 (set-fontset-font t 'symbol "Noto Sans Symbols" nil 'append)
			 (set-fontset-font t 'symbol "Noto Sans Symbols 2" nil 'append)
			 (set-fontset-font t 'emoji "Noto Color Emoji")

			 (set-fontset-font t 'han "Sarasa Term SC")
			 (set-fontset-font t 'cjk-misc "Sarasa Term SC")
			 (set-fontset-font t 'playing-cards "Noto Sans Symbols" nil 'append)
			 (set-fontset-font t 'playing-cards "Noto Sans Symbols 2" nil 'append)
			 (set-fontset-font "fontset-default" '(#x2026 . #x2026)
							   "Sarasa Term SC Nerd")


			 (set-face-attribute
			  'font-lock-keyword-face nil :weight 'bold :slant 'italic :foreground "red")
			 (set-face-attribute
			  'font-lock-type-face nil :foreground "green")
			 (set-face-attribute
			  'font-lock-preprocessor-face nil :foreground "bisque")
			 (set-face-attribute
			  'font-lock-variable-name-face nil :foreground "orchid")
			 (set-face-attribute
			  'font-lock-variable-use-face nil :foreground "cyan")
			 (set-face-attribute
			  'font-lock-comment-face nil :weight 'ultra-light)
			 (set-face-attribute 'font-lock-function-name-face
								 nil :weight 'ultra-bold)
			 (set-face-attribute 'highlight nil
								 :background "#2a2a2a"
								 :inverse-video nil
								 :box '(:line-width (-1 . -1) :color "grey75")
								 )
			 ))

;; (setq face-font-rescale-alist '(
;; 								("Sarasa Term SC" . 1.0)
;; 								;; ("Noto Color Emoji" . 1.0)
;; 								;; ("Symbols Nerd Font Mono" . 1.0)
;; 								))


(add-hook 'after-init-hook '(lambda()
							  (setq left-margin-width 1 right-margin-width 0)
							  (fringe-mode nil)
							  ))
(set-face-attribute 'fringe nil :background "black")

(set-background-color "black")
(provide 'emacs-early-init)

;;; emacs-early-init.el ends here
