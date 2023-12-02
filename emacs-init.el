;;; package --- Summary -*- lexical-binding: t -*-
;;; Code:


(setq debug-on-error t)
(setq debug-on-signal nil)
(setq disabled-command-function nil)

(setq evil-want-keybinding nil
	  forge-add-default-bindings nil
	  )

(setq-default
 safe-local-variable-directories '(
								   "/home/exec/Projects/github.com/"
								   )
 safe-local-variable-values
 '((eval setenv "PKG_CONFIG_PATH_FOR_TARGET"
		 "/nix/store/nkywiick4sqkdcbk99n9mv6y30q8a2m0-openssl-3.0.10-dev/lib/pkgconfig"))
 )





(setq url-proxy-services '(("no_proxy" . "^\\(localhost\\|10\\..*\\|192\\.168\\..*\\)")
						   ("http" . "127.0.0.1:7890")
						   ("https" . "127.0.0.1:7890")))






(setq-default straight-repository-branch "develop")

(setq-default straight-check-for-modifications nil)


(defvar bootstrap-version)
(let ((bootstrap-file
	   (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
	  (bootstrap-version 6))
  (unless (file-exists-p bootstrap-file)
	(with-current-buffer
		(url-retrieve-synchronously
		 "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
		 'silent 'inhibit-cookies)
	  (goto-char (point-max))
	  (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))


(setq custom-file "/home/exec/.emacs.d/emacs-custom.el")

(straight-use-package 'use-package)
(straight-use-package 'org)




										; ;; Configure use-package to use straight.el by default
(use-package straight
  :custom
  (straight-use-package-by-default t)
  )

(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)

(setq custom-safe-themes t)

(use-package color-theme-sanityinc-tomorrow)
(load-theme 'sanityinc-tomorrow-bright)



(defun exec/with-face (str &rest face-plist)
  (propertize str 'face face-plist))
(defun exec/make-header ()
  ""
  (let* ((exec/full-header (abbreviate-file-name buffer-file-name))
		 (exec/header (file-name-directory exec/full-header))
		 (exec/drop-str "[...]"))
	(if (> (length exec/full-header)
		   (window-body-width))
		(if (> (length exec/header)
			   (window-body-width))
			(progn
			  (concat (exec/with-face exec/drop-str
									  :background "blue"
									  :weight 'bold
									  )
					  (exec/with-face (substring exec/header
												 (+ (- (length exec/header)
													   (window-body-width))
													(length exec/drop-str))
												 (length exec/header))
									  ;; :background "red"
									  :weight 'bold
									  )))
		  (concat (exec/with-face exec/header
								  ;; :background "red"
								  :foreground "#8fb28f"
								  :weight 'bold
								  )))
	  (concat (exec/with-face exec/header
							  ;; :background "green"
							  ;; :foreground "black"
							  :weight 'bold
							  :foreground "#8fb28f"
							  )
			  (exec/with-face (file-name-nondirectory buffer-file-name)
							  :weight 'bold
							  ;; :background "red"
							  )))))
(defun exec/display-header ()
  (setq header-line-format
		'("" ;; invocation-name
		  (:eval (if (buffer-file-name)
					 (exec/make-header)
				   "%b")))))
;; (add-hook 'buffer-list-update-hook
;; 		  'exec/display-header)

(defun exec/split-window-sensibly-prefer-horizontal (&optional window)
  "Based on split-window-sensibly, but designed to prefer a horizontal split,
i.e. windows tiled side-by-side."
  (let ((window (or window (selected-window))))
    (or (and (window-splittable-p window t)
			 ;; Split window horizontally
			 (with-selected-window window
			   (split-window-right)))
		(and (window-splittable-p window)
			 ;; Split window vertically
			 (with-selected-window window
			   (split-window-below)))
		(and
         ;; If WINDOW is the only usable window on its frame (it is
         ;; the only one or, not being the only one, all the other
         ;; ones are dedicated) and is not the minibuffer window, try
         ;; to split it horizontally disregarding the value of
         ;; `split-height-threshold'.
         (let ((frame (window-frame window)))
           (or
            (eq window (frame-root-window frame))
            (catch 'done
              (walk-window-tree (lambda (w)
                                  (unless (or (eq w window)
                                              (window-dedicated-p w))
                                    (throw 'done nil)))
                                frame)
              t)))
		 (not (window-minibuffer-p window))
		 (let ((split-width-threshold 0))
		   (when (window-splittable-p window t)
			 (with-selected-window window
               (split-window-right))))))))

(defun exec/split-window-really-sensibly (&optional window)
  (let ((window (or window (selected-window))))
    (if (> (window-total-width window) (* 2 (window-total-height window)))
        (with-selected-window window (exec/split-window-sensibly-prefer-horizontal window))
      (with-selected-window window (split-window-sensibly window)))))



;; a few more useful configurations...
(use-package emacs
  :init
  (global-unset-key (kbd "C-j"))
  (global-unset-key (kbd "C-k"))
  (global-unset-key (kbd "C-h"))
  (global-unset-key (kbd "C-l"))
  (global-unset-key (kbd "M-j"))
  (global-unset-key (kbd "M-k"))
  (global-unset-key (kbd "M-h"))
  (global-unset-key (kbd "M-l"))
  (global-unset-key (kbd "M-i"))
  (global-unset-key (kbd "M-o"))
  (setq-default line-spacing 0)

  (setq max-mini-window-height 0.5)

  (setq-default bidi-display-reordering nil)
  (setq bidi-inhibit-bpa t
		large-hscroll-threshold 1000
		long-line-threshold 1000
		syntax-wholeline-max 1000)


  (setq switch-to-buffer-obey-display-actions t)
  (setq auto-save-default nil)
  (setq next-line-add-newlines t)
  (setq mouse-wheel-flip-direction t
		mouse-wheel-tilt-scroll t
		)
  (setq-default indicate-empty-lines nil)
  (setq font-lock-maximum-decoration
		1
		;; '(
		;; 							   (markdown-mode . nil)
		;; 							   (t . 2)
		;; 							   )
		)
  ;; (setq display-buffer-base-action '(nil . ((inhibit-same-window . t))))

  (setq mode-line-compact nil
		mode-line-in-non-selected-windows t
		mode-line-percent-position nil
		mode-line-position-column-line-format '("[%l,%c]")
		)
  ;; (setq mode-line-format nil)
  ;; (setq mode-line-format
  ;; 		'("%e"
  ;; 		  mode-line-front-space
  ;; 		  ;; (:propertize
  ;; 		  ;;  ("" mode-line-mule-info mode-line-client mode-line-modified
  ;; 		  ;; 	mode-line-remote)
  ;; 		  ;;  display (min-width (5.0)))
  ;; 		  mode-line-frame-identification
  ;; 		  mode-line-buffer-identification

  ;; 		  mode-line-format-right-align

  ;; 		  minions-mode-line-modes
  ;; 		  mode-line-position
  ;; 		  evil-mode-line-tag
  ;; 		  (vc-mode vc-mode)
  ;; 		  "  "
  ;; 		  ;; mode-line-misc-info
  ;; 		  mode-line-end-spaces
  ;; 		  )
  ;; 		)

  (setopt mode-line-format
          '("%e"
			mode-line-front-space
            (:propertize
			 ("" mode-line-mule-info mode-line-client mode-line-modified mode-line-remote)
			 display
			 (min-width (5.0)))
            mode-line-frame-identification
            mode-line-buffer-identification

            mode-line-format-right-align

            mode-line-position
			(vc-mode vc-mode)
            mode-line-modes
            mode-line-misc-info
            mode-line-end-spaces))

  (set-face-attribute 'mode-line nil :height 0.8)

  (setq vc-follow-symlinks t)
  (setq completion-cycle-threshold 3)
  (setq tab-always-indent 'complete)
  (setq visible-bell t)
  (setq ring-bell-function
		;; 'exec/double-flash-mode-line
		'ignore
		)
  (setq show-paren-ring-bell-on-mismatch t)
  (setq large-file-warning-threshold 1000000000)
  (setq read-process-output-max (* 1024 1024))
  (setq undo-limit 10000)
  (setq initial-scratch-message nil)
  (setq inhibit-x-resources t)
  (setq package-native-compile t)
  (setq buffer-save-without-query t)
  (setq byte-compile-warnings '(unresolved))
  (setq max-lisp-eval-depth 1100)

  ;; (setq frame-title-format "Eval EXEC - GNU Emacs at Mufasa")
  (setq header-line-format '(:eval (if (buffer-file-name) (abbreviate-file-name (buffer-file-name)) "%b")))


  ;; (defun crm-indicator (args)
  ;; 	(cons (format "[CRM%s] %s"
  ;; 				  (replace-regexp-in-string
  ;; 				   "\\`\\[.*?]\\*\\|\\[.*?]\\*\\'" ""
  ;; 				   crm-separator)
  ;; 				  (car args))
  ;; 		  (cdr args)))
  ;; (advice-add #'completing-read-multiple :filter-args #'crm-indicator)

  ;; Do not allow the cursor in the minibuffer prompt
  ;; (setq minibuffer-prompt-properties
  ;; 		'(read-only t cursor-intangible t face minibuffer-prompt))
  ;; (add-hook 'minibuffer-setup-hook #'cursor-intangible-mode)

  ;; Emacs 28: Hide commands in M-x which do not work in the current mode.
  ;; Vertico commands are hidden in normal buffers.
  ;; (setq read-extended-command-predicate
  ;; 		#'command-completion-default-include-p)

  ;; (defun my-minibuffer-setup ()
  ;; 	(set (make-local-variable 'face-remapping-alist)
  ;;         '((default :height 0.8))))
  ;; (add-hook 'minibuffer-setup-hook 'my-minibuffer-setup)


  ;; Enable recursive minibuffers
  (setq enable-recursive-minibuffers t)
  (setq column-number-mode t)
  (setq line-number-mode t)
  ;; (setq mode-line-percent-position '(-3 "%o"))

  ;; (add-to-list 'default-frame-alist '(foreground-color . "white"))
  ;; (add-to-list 'default-frame-alist '(background-color . "black"))
  (set-cursor-color "green")

  (pixel-scroll-precision-mode 1)

  (setq
   ;; pixel-scroll-precision-large-scroll-height nil
   ;; pixel-scroll-precision-interpolation-total-time 0.2
   ;; pixel-scroll-precision-momentum-min-velocity 0
   ;; pixel-scroll-precision-interpolation-factor 1.0
   ;; pixel-scroll-precision-interpolate-page t
   )

  (defun exec/scroll-up (&optional lines)
	(interactive)
	(if lines
		(pixel-scroll-precision-interpolate (- (* lines (pixel-line-height))))
	  (pixel-scroll-interpolate-up)))

  (defun exec/scroll-down (&optional lines)
	(interactive)
	(if lines
		(pixel-scroll-precision-interpolate (* lines (pixel-line-height))))
	(pixel-scroll-interpolate-down))


  (defun exec/scroll-half-up()
	(interactive)
	(exec/scroll-up (floor (/ (frame-height) 2)))
	)

  (defun exec/scroll-half-down()
	(interactive)
	(exec/scroll-down (floor (/ (frame-height) 2))))



  (setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; one line at a time

  (setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling

  (setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse

  (setq scroll-step 1) ;; keyboard scroll one line at a time




  (setq revert-without-query '(".*"))




  :hook
  (
   ;; (after-init . savehist-mode)
   ;; (after-init . size-indication-mode)
   (after-init . global-auto-revert-mode)
   )
  ;; (frame-width)
  ;; (frame-height)
  :config
  (setq split-height-threshold 40
		split-width-threshold 160
		split-window-preferred-function 'exec/split-window-really-sensibly
		)

  )
(use-package display-line-numbers
  :hook
  (prog-mode . display-line-numbers-mode)
  :config
  (setq display-line-numbers-type t
		display-line-numbers-grow-only t
		display-line-numbers-width 2
		display-line-numbers-widen t
		)
  )



(defun exec/increase-buffer-font()
  (interactive)
  (setq-local buffer-face-mode-face '(:height 1.2))
  (buffer-face-mode))

(defun exec/decrease-buffer-font()
  (interactive)
  (setq-local buffer-face-mode-face '(:height 0.8))
  (buffer-face-mode))


(use-package general
  :demand t
  :config
  (general-create-definer global-definer
	:keymaps 'override
	:states  '(insert emacs normal hybrid motion visual operator)
	:prefix  "SPC"
	:non-normal-prefix "S-SPC")
  (defmacro +general-global-menu! (name infix-key &rest body)
	"Create a definer named +general-global-NAME wrapping global-definer.
Create prefix map: +general-global-NAME. Prefix bindings in BODY with INFIX-KEY."
	(declare (indent 2))
	`(progn
	   (general-create-definer ,(intern (concat "+general-global-" name))
		 :wrapping global-definer
		 :prefix-map (quote ,(intern (concat "+general-global-" name "-map")))
		 :infix ,infix-key
		 :wk-full-keys nil
		 "" '(:ignore t :which-key ,name))
	   (,(intern (concat "+general-global-" name))
		,@body)))

  (general-create-definer global-leader
	:keymaps 'override
	:states '(emacs normal hybrid motion visual operator)
	:prefix "SPC m"
	"" '(:ignore t :which-key (lambda (arg) `(,(cadr (split-string (car arg) " ")) . ,(replace-regexp-in-string "-mode$" "" (symbol-name major-mode))))))
  )


(use-package evil
  :straight (:type built-in)
  :init
  (setq evil-want-integration t
		evil-respect-visual-line-mode t
		evil-v$-excludes-newline t
		evil-want-C-u-scroll t
		evil-want-C-i-jump t
		evil-want-C-u-delete t
		evil-want-fine-undo t)

  :demand t
  :config
  (evil-mode t)
  (general-evil-setup)

  (setopt evil-disable-insert-state-bindings nil
		  evil-search-module 'evil-search
		  evil-symbol-word-search t
		  evil-move-beyond-eol nil
		  evil-split-window-below t
		  evil-vsplit-window-right t
		  )

  ;; (defalias #'forward-evil-word #'forward-evil-symbol)

  (setq evil-want-minibuffer t)
  (setq evil-jumps-cross-buffers t)
  (setq evil-search-wrap-ring-bell t) ;;

  (evil-set-undo-system  'undo-redo)


  (setq evil-ex-search-highlight-all nil)
  (setq undo-tree-auto-save-history nil)

  ;; (evil-define-key 'normal org-mode-map (kbd "<tab>") #'org-cycle)
  ;; (evil-define-key 'normal org-mode-map (kbd "RET") #'org-return)
  (with-eval-after-load 'evil-maps
	;; (define-key evil-motion-state-map (kbd "SPC") nil)
	(define-key evil-motion-state-map (kbd "RET") nil)
	(define-key evil-motion-state-map (kbd "TAB") nil)
	(define-key evil-motion-state-map (kbd "C-o") 'evil-jump-backward)
	(define-key evil-motion-state-map (kbd "C-i") 'evil-jump-forward)
	)

  (general-define-key [remap evil-quit] 'kill-buffer-and-window)

  (evil-add-command-properties #'find-file-at-point :jump t)
  (evil-add-command-properties #'consult-line :jump t)
  (evil-add-command-properties #'org-agenda-switch-to :jump t)
  (evil-add-command-properties #'org-return :jump t)
  (evil-add-command-properties #'evil-scroll-page-up :jump t)
  (evil-add-command-properties #'evil-scroll-page-down :jump t)
  (evil-add-command-properties #'backward-up-list :jump t)

  (setq evil-normal-state-tag   (propertize "<N>" 'face '((:background "darkgreen"   :foreground "white")))
		evil-emacs-state-tag    (propertize "<E>" 'face '((:background "yellow"    :foreground "black")))
		evil-insert-state-tag   (propertize "<I>" 'face '((:background "red"       :foreground "yellow")))
		evil-replace-state-tag  (propertize "<R>" 'face '((:background "orange" :foreground "black")))
		evil-motion-state-tag   (propertize "<M>" 'face '((:background "plum3"     :foreground "black")))
		evil-visual-state-tag   (propertize "<V>" 'face '((:background "purple"    :foreground "white")))
		evil-operator-state-tag (propertize "<O>" 'face '((:background "blue"      :foreground "white"))))

  ;; (defalias 'evil-scroll-page-up 'exec/scroll-up)
  ;; (defalias 'evil-scroll-page-down 'exec/scroll-down)
  ;; (defalias 'evil-scroll-up 'exec/scroll-half-down)
  ;; (defalias 'evil-scroll-down 'exec/scroll-half-up)

  )

(general-nmap
  "C-i" 'evil-jump-forward
  )
(defun exec/disable-y-or-n-p (orig-fun &rest args)
  (cl-letf (((symbol-function 'y-or-n-p) (lambda (prompt) t)))
    (apply orig-fun args)))


(use-package ediff
  :straight (:type built-in)
  :hook
  (ediff-after-setup-control-frame . (lambda()
									   (interactive)
									   (tab-line-mode -1)
									   (tab-bar-mode -1)
									   ))
  :config
  (setopt ediff-split-window-function 'split-window-horizontally)

  (advice-add 'ediff-quit :around #'exec/disable-y-or-n-p)

  (general-nmap :keymaps 'ediff-meta-mode-map
	"C-j" 'ediff-next-meta-item
	"C-k" 'ediff-previous-meta-item
	)
  )


(use-package magit
  :straight (:type built-in)
  :config
  (setq magit-revision-show-gravatars t)

  (use-package forge
    :straight (:type built-in)
    :after magit
    )
  (use-package magit-delta
    ;; :hook (magit-mode . magit-delta-mode))
    )
  )

(use-package evil-collection
  :straight (:type built-in)
  :after evil
  :custom
  (evil-collection-setup-minibuffer t)
  (evil-collection-want-find-usages-bindings t)
  :config
  (evil-collection-init))

(use-package evil-cleverparens
  ;; :hook
  ;; (emacs-lisp-mode .
  ;; 				   evil-cleverparens-mode)
  :config
  )


;; (use-package unicode-fonts
;;   :config
;;   (unicode-fonts-setup)
;;   )


(use-package el-patch)

;; ;; uses the given recipe
(use-package info-colors
  :straight (info-colors :type git :host github :repo "ubolonton/info-colors")
  :commands (info-colors-fontify-node)
  :hook
  (Info-selection . info-colors-fontify-node)
  )


(defun sh/current-time-microseconds ()
  "Return the current time formatted to include microseconds."
  (let* ((nowtime (current-time))
		 (now-ms (nth 2 nowtime)))
	(concat (format-time-string "[%Y-%m-%dT%T" nowtime) (format ".%d]" now-ms))))

(defun sh/ad-timestamp-message (FORMAT-STRING &rest args)
  "Advice to run before `message' that prepends a timestamp to each message.

  /home/exec/.emacs.d/Activate this advice with:
  (advice-add 'message :before 'sh/ad-timestamp-message)"
  (unless (string-equal FORMAT-STRING "%s%s")
	(let ((deactivate-mark nil)
		  (inhibit-read-only t))
	  (with-current-buffer "*Messages*"
		(goto-char (point-max))
		(if (not (bolp))
			(newline))
		(insert (sh/current-time-microseconds) " ")))))

;; (advice-add 'message :before 'sh/ad-timestamp-message)
;; (advice-remove 'message 'sh/ad-timestamp-message)

(setq warning-suppress-log-types '((comp))
	  warning-suppress-types '((comp)))

(toggle-scroll-bar -1)
(setq scroll-conservatively 1000
	  scroll-margin 0
	  ;; 	  scroll-step 0
	  ;; 	  scroll-preserve-screen-position nil
	  ;; 	  scroll-up-aggressively nil
	  ;; 	  scroll-down-aggressively nil
	  ;; 	  fast-but-imprecise-scrolling t
	  )

(setq make-pointer-invisible nil)
(setq mouse-highlight t)
(setq-default tab-width 4)

(setq-default cursor-in-non-selected-windows nil)

(setq blink-cursor-blinks -1
	  blink-cursor-delay 0
	  blink-cursor-interval 0.01)
(blink-cursor-mode -1)

(setq word-wrap-by-category t)
(setq echo-keystrokes nil)
(setq display-time-24hr-format t
	  display-time-day-and-date t
	  display-time-default-load-average nil
	  display-time-interval 1
	  display-time-format "%H:%M:%S"
	  )




(setq history-delete-duplicates t)

(setq display-buffer-base-action nil)
(setq create-lock-file nil)




(setq-default tab-width 4)
(setq-default c-basic-offset 4)

(setq word-wrap t)
(global-visual-line-mode -1)


(setq native-comp-async-report-warnings-errors nil)
(setq imenu-auto-rescan t)


(setq make-backup-files nil)
(setq create-lockfiles nil)


(setq org-roam-v2-ack t)

(setq inhibit-compacting-font-caches t)

(setq require-final-newline t)
(setq load-prefer-newer t)


(set-default-coding-systems 'utf-8)

(setenv "LSP_USE_PLISTS" "true")
(setenv "SHELL" "zsh")
;; (setenv "PKG_CONFIG_PATH" "/nix/store/80rbkkz1jh3ybsc5r4dz2bmn02vljn1c-openssl-3.0.8-dev/lib/pkgconfig")
(setenv "LD_LIBRARY_PATH" "/run/current-system/sw/share/nix-ld/lib")

(setenv "LANG" "en_US.UTF-8")
(setenv "LC_ALL" "en_US.UTF-8")
;; (setenv "LC_CTYPE" "zh_CN.UTF-8")
(setenv "GOARCH" "amd64")
(setenv "TERM" "xterm-256color")
;; (setenv "GTK_IM_MODULE" "fcitx")
;; (setenv "INPUT_METHOD" "fcitx")
;; (setenv "QT_IM_MODULE" "fcitx")
;; (setenv "SDL_IM_MODULE" "fcitx")
;; (setenv "XMODIFIERS" "@im=fcitx")
;; (setenv "PATH" "/nix/store/k2j9x9kzss7jhqvwsaas9ikyiq8031q5-xwininfo-1.1.6/bin:/nix/store/ycvfy4cg0ky81gp0566dpdl6apxjzrjx-xdotool-3.20211022.1/bin:/nix/store/5fa4i3i5dgqk49lxbz952jnph01im948-xprop-1.2.6/bin:/nix/store/3mpa96b8hi3gfx17099xwgfnp6kbz4ga-gawk-5.2.2/bin:/nix/store/8fdd0nqajq5sk1m6p4qnn0z0j9d7n3q5-coreutils-9.3/bin:/nix/store/2hz0i9y0xck9y4pq1rabi0cwk4kylgrw-gnugrep-3.11/bin:/nix/store/sxk30xba5nyvw8p10pfpgq5p9skhhi0a-procps-3.3.17/bin:/home/exec/.cargo/bin:/home/exec/.local/bin:/run/wrappers/bin:/home/exec/.nix-profile/bin:/etc/profiles/per-user/exec/bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin:/home/exec/.oh-my-zsh/custom/plugins/warhol/bin:/home/exec/.oh-my-zsh/custom/plugins/warhol/bin")

;; (add-to-list 'exec-path "/home/exec/.local/bin")
										; (add-to-list 'exec-path "/home/exec/.cargo/bin")
										; (add-to-list 'exec-path "/home/exec/.local/bin")
;; (setenv "HTTP_PROXY" "socks5://127.0.0.1:7891")
;; (setenv "HTTPS_PROXY" "socks5://127.0.0.1:7891")
;; (setenv "ALL_PROXY" "socks5://127.0.0.1:7891")

(setq exec/golden-ratio 0.618)


;; (defun adjust-window-split-thresholds nil
;;   "Adjust split thresholds so that popup windows always split vertically in a tall frame, horizontally in a wide frame, with a maximum of two columns"
;;   (interactive)
;;   (if (>= (frame-pixel-width) (frame-pixel-height))
;; 										; wide frame
;; 	  (progn
;; 		(setq split-height-threshold (frame-height))
;; 		(setq split-width-threshold  (/ (frame-width) 2))
;; 		)
;; 										; tall frame
;; 	(progn
;; 	  (setq split-height-threshold (frame-height))
;; 	  (setq split-width-threshold  (frame-width))
;; 	  ))
;;   )
;; (add-hook 'window-configuration-change-hook 'adjust-window-split-thresholds)
;; (remove-hook 'window-configuration-change-hook 'adjust-window-split-thresholds)



;;; package --- Summary
;;; Commentary:

(defun exec/imenu-goto--closest-dir (direction)
  "Jump to the closest imenu item on the current buffer.
If direction is 1, jump to next imenu item.
If direction is -1, jump to previous imenu item.
See https://emacs.stackexchange.com/questions/30673
Adapted from `which-function' in::
https://github.com/typester/emacs/blob/master/lisp/progmodes/which-func.el"
  ;; Ensure `imenu--index-alist' is populated.
  (imenu--make-index-alist)

  (let ((alist imenu--index-alist)
        (minoffset (point-max))
        offset pair mark imstack destination)
    ;; Elements of alist are either ("name" . marker), or
    ;; ("submenu" ("name" . marker) ... ). The list can be
    ;; Arbitrarily nested.
    (while (or alist imstack)
      (if alist
          (progn
            (setq pair (car-safe alist)
                  alist (cdr-safe alist))
            (cond
             ((atom pair)) ;; Skip anything not a cons.

             ((imenu--subalist-p pair)
              (setq imstack   (cons alist imstack)
                    alist     (cdr pair)))

             ((number-or-marker-p (setq mark (cdr pair)))
              (when (> (setq offset (* (- mark (point)) direction)) 0)
                (when (< offset minoffset) ;; Find the closest item.
                  (setq minoffset offset
                        destination mark))))))

        (setq alist   (car imstack)
              imstack (cdr imstack))))
    (when destination
      (imenu-default-goto-function "" destination ""))))

(defun exec/imenu-goto-next ()
  (interactive)
  (sit-for 0)
  (unless (exec/imenu-goto--closest-dir 1)
    (goto-char (point-max)))
  (recenter)
  )

(defun exec/imenu-goto-prev ()
  (interactive)
  (sit-for 0)
  (unless (exec/imenu-goto--closest-dir -1)
    (goto-char (point-min)))
  (recenter)
  )

(defun exec/consult-imenu-or-outline()
  "First run `consult-imenu'.
if it encounter an error, then we execute `consult-outline'."
  (interactive)
  (condition-case nil
	  (consult-imenu)
	(error (consult-outline)))
  )



;;;;;;;;;;;;;;;;;;;;;; general ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(general-define-key :states '(normal visual) :keymaps 'override
					"M-j" 'exec/imenu-goto-next
					"M-k" 'exec/imenu-goto-prev
					)


(general-def :keymaps '(insert motion emacs)
  "C-S-v" 'yank
  )


(general-nmap ;; "C-S-" prefix
  "C-S-c" 'exec/put-file-name-on-clipboard)


(global-definer ;; Default Space prefix
  "i" 'exec/consult-imenu-or-outline
  "I" 'consult-imenu-multi
  "!"   'shell-command
  ":"   'eval-expression

  "f" 'consult-projectile-find-file
  "F" 'consult-projectile-find-file-other-window
  "r" 'consult-projectile-recentf
  "b" 'consult-projectile-switch-to-buffer
  "B" 'consult-projectile-switch-to-buffer-other-window
  "s" 'lsp-ui-find-workspace-symbol
  )

(+general-global-menu! "Git" "v"
  "g" 'git-timemachine
  "v" 'magit-status
  "l" 'magit-log-buffer-file
  )

(+general-global-menu! "Double Space" "SPC"
  "SPC" 'execute-extended-command

  "d"  'kill-current-buffer
  "o" '((lambda () (interactive) (switch-to-buffer nil))
		:which-key "other-buffer")
  "p"  'previous-buffer
  "r"  'rename-buffer
  "M" '((lambda () (interactive) (switch-to-buffer "*Messages*"))
		:which-key "messages-buffer")
  "n"  'next-buffer
  "s" '((lambda () (interactive) (switch-to-buffer "*scratch*"))
		:which-key "scratch-buffer")
  "TAB" '((lambda () (interactive) (switch-to-buffer nil))
		  :which-key "other-buffer")
  "b" 'bufler
  "k" 'kill-current-buffer
  )

(+general-global-menu! "org-roam" "n"

  "l" 'org-roam-buffer-toggle
  "f" 'org-roam-node-find
  "s" 'consult-org-roam-search
  "F" 'org-roam-ref-find
  "g" 'org-roam-graph
  "i" 'org-roam-node-insert
  "I" 'org-id-get-create
  "c" 'org-roam-capture
  "R" 'org-roam-refile

  ;; org roam properties
  "o" '(nil :which-key "Org Roam Properties")
  "o a" 'org-roam-alias-add
  "o A" 'org-roam-alias-remove
  "o t" 'org-roam-tag-add
  "o T" 'org-roam-tag-remove
  "o r" 'org-roam-ref-add
  "o R" 'org-roam-ref-remove

  ;; org roam dailies
  "d" '(nil :which-key "Org Roam Dailies")
  "d c d" 'org-roam-dailies-capture-date
  "d c c" 'org-roam-dailies-capture-today
  "d c m" 'org-roam-dailies-capture-tomorrow
  "d c y" 'org-roam-dailies-capture-yesterday
  "d d" 'org-roam-dailies-goto-date
  "d m" 'org-roam-dailies-goto-tomorrow
  "d t" 'org-roam-dailies-goto-today
  "d y" 'org-roam-dailies-goto-yesterday
  "d -" 'org-roam-dailies-find-directory
  )

(+general-global-menu! "Emacs Stuff" "e"
  "c" 'customize-group
  "h" '(nil :which-key "Emacs Hook")
  "hr" 'remove-hook
  "f" '(lambda()
		 (interactive)
		 (let ((consult-project-root-function (lambda nil nil))
			   (consult-ripgrep-args
				(concat "rg "
						"--null "
						"--line-buffered "
						"--color=never "
						"--line-number "
						"--smart-case "
						"--no-heading "
						"--max-columns=1000 "
						"--max-columns-preview "
						"--search-zip "
						"--with-filename "
						(shell-quote-argument "/home/exec/.emacs.d/init.el" ))))
		   (consult-ripgrep))
		 )
  )


(+general-global-menu! "Keybinding" "k"

  "M" '(nil :which-key "Major mode Keybinding")
  "Mk" 'which-key-show-major-mode
  "MK" 'which-key-show-full-major-mode

  "m" '(nil :which-key "Minor mode Keybinding")
  "mk" 'which-key-show-minor-mode-keymap
  "mK" 'which-key-show-full-minor-mode-keymap
  )

(+general-global-menu! "Org Mode" "o"
  "l" 'org-cliplink
  "a" 'exec/org-agenda-transient
  "c" 'org-capture
  "j" 'org-journal-new-entry
  "m" 'org-redisplay-inline-images
  )

(+general-global-menu! "Consult" "c"
  "m" 'woman
  )


(+general-global-menu! "Misc" "m"
  "s" 'deadgrep
  "r" 'rust-playground
  ;; "t" 'bing-dict-brief
  ;; "t" 'fanyi-dwim2
  ;; "t" 'exec/look-up-dict-at-point
  "t" 'gts-do-translate
  "T" 'exec/prompt-dict
  ;; "T" nil :which-key "Toggle"
  ;; "=" 'cnfonts-increase-fontsize
  ;; "-" 'cnfonts-decrease-fontsize
  "=" 'text-scale-increase
  "-" 'text-scale-decrease
  "c" 'calendar
  )

(general-define-key :prefix "C-c"
					"o" '(nil :which-key "Org")
					"oa" 'exec/org-agenda-transient
					"oc" 'org-capture
					"oj" 'org-journal-new-entry

					"s" 'deadgrep

					"n" '(nil :which-key "Org Roam")
					"nl" 'org-roam-buffer-toggle
					"nf" 'org-roam-node-find
					"ns" 'consult-org-roam-search
					"nF" 'org-roam-ref-find
					"ng" 'org-roam-graph
					"ni" 'org-roam-node-insert
					"nI" 'org-id-get-create
					"nc" 'org-roam-capture
					"nr" 'org-roam-refile

					;; org roam properties
					"no" '(nil :which-key "Org Roam Properties")
					"noa"  'org-roam-alias-add
					"noA"  'org-roam-alias-remove
					"not"  'org-roam-tag-add
					"noT"  'org-roam-tag-remove
					"nor"  'org-roam-ref-add
					"noR"  'org-roam-ref-remove
					"nd" '(nil :which-key "Org Roam Dailies")
					"ndcd" 'org-roam-dailies-capture-date
					"ndcc" 'org-roam-dailies-capture-today
					"ndcm" 'org-roam-dailies-capture-tomorrow
					"ndcy" 'org-roam-dailies-capture-yesterday
					"ndd"  'org-roam-dailies-goto-date
					"ndm"  'org-roam-dailies-goto-tomorrow
					"ndt"  'org-roam-dailies-goto-today
					"ndy"  'org-roam-dailies-goto-yesterday
					"nd-"  'org-roam-dailies-find-directory
					)



;;; hyper key bindings
(global-set-key (kbd "H-h") 'help-command)

(general-def :prefix "H-h"
  "k" 'helpful-key
  "v" 'helpful-variable
  "o" 'helpful-symbol
  "P" 'helpful-at-point
  "f" 'helpful-function
  "m" 'helpful-macro
  "c" 'helpful-command
  "C" 'helpful-callable

  "a" 'info-apropos
  "i" 'consult-info
  )

(general-def :keymaps 'prog-mode-map
  "M-q" 'format-all-buffer
  )

(general-def :keymaps 'universal-argument-map
  "H-u" 'universal-argument-more
  )

(general-def ;; C-H prefix
  "C-H-<left>" 'tab-bar-switch-to-prev-tab
  "C-H-<right>" 'tab-bar-switch-to-next-tab
  "C-H-<up>" 'tab-bar-rename-tab
  "C-H-SPC" 'which-key-show-minor-mode-keymap
  )

(general-def ;; Hyper prefix
  "H-u" 'universal-argument
  "H-a" 'exec/org-agenda-transient
  "H-`" 'garbage-collect
  "H-h" 'help-command
  "H-k" 'kill-current-buffer
  "H-<left>" 'winner-undo
  "H-<right>" 'winner-redo
  "H-M-SPC" 'exec/which-key-show-top-level
  "H-SPC" 'which-key-show-major-mode
  "H-z" 'repeat
  )

(general-def ;; Super prefix
  "s-h" 'tab-line-switch-to-prev-tab
  "s-l" 'tab-line-switch-to-next-tab
  "s-H" 'intuitive-tab-line-shift-tab-left
  "s-L" 'intuitive-tab-line-shift-tab-right
  "s-o" 'other-window
  ;; "s-n" 'exec/toggle-dired
  "s-n" 'treemacs-select-window
  "M-m" 'projectile-commander
  )

(defun exec/toggle-dired()
  (interactive)
  (if (bound-and-true-p diredfl-mode) (quit-window)
	(exec/dired-current-directory)))


(general-imap 'global
  "<escape>" '(lambda()
				(interactive)
				(if (bound-and-true-p corfu-mode)
					(corfu-quit))
				(if (bound-and-true-p copilot-mode)
					(copilot-clear-overlay))
				(evil-force-normal-state)
				)
  "C-h" 'left-char
  "C-l" 'right-char
  "C-j" 'next-line
  "C-k" 'previous-line
  "C-SPC" 'completion-at-point
  )

(general-imap :keymaps 'minibuffer-mode-map
  "C-k" 'previous-line-or-history-element
  "C-j" 'next-line-or-history-element
  "C-v" 'yank
  )

(defun exec/tab-in-insert-mode-command()
  (interactive)
  (if (copilot--overlay-visible)
	  (copilot-accept-completion)
	))


(general-define-key
 :keymaps 'projectile-command-map
 "f" 'consult-projectile-find-file
 "b" 'consult-projectile-switch-to-buffer
 "B" 'consult-projectile-switch-to-buffer-other-window
 "p" 'consult-projectile-switch-project
 "P" 'tab-bar-new-tab
 )

(general-define-key :keymaps 'flycheck-mode-map
					"<f2>" 'flycheck-next-error
					)

(general-define-key :keymaps 'origami-mode-map
					"<tab>" 'origami-recursively-toggle-node
					"<backtab>" 'origami-toggle-all-nodes
					)

(general-define-key :keymaps 'diff-hl-mode-map
					"C-M-z" 'diff-hl-revert-hunk
					)

(general-define-key :keymaps 'flycheck-mode-map
					"M-g n" 'flycheck-next-error
					)

(general-nmap :keymaps 'treemacs-mode-map
  "p" 'treemacs-goto-parent-node
  )


(general-evil-define-key 'normal 'global
  "M-f" 'consult-line
  )


(defun exec/open-config()
  "Open config file."
  (interactive)
  ;; if "init.el" buffer has already opened in current frame, then focus to that window
  (if (equal (buffer-name) "init.el")
	  (switch-to-buffer (other-buffer))
	;; open user-init-file buffer of open this file
	;; (if (get-buffer "init.el")
	;; 	(switch-to-buffer "init.el")
	(if (get-buffer-window "init.el")
		(select-window (get-buffer-window "init.el"))
	  (find-file "~/.emacs.d/init.el"))
	)
  )

(global-set-key (kbd "<f12>") 'exec/open-config)

;; (general-def
;;   :prefix "C-x"
;;   "h" 'previous-buffer
;;   "l" 'next-buffer
;;   )

;; define C-x C-e in evil visual line mode to eval-region
(general-evil-define-key 'visual 'global
  "C-x C-e" 'eval-region
  )

(defun exec/dired-current-directory()
  (interactive)
  (projectile-dired)
  ;; (dired default-directory)
  )

;; (defun exec/consult-ripgrep()
;;   (interactive)
;;   (consult-ripgrep nil (exec/thing-at-point)))

;; (defun exec/consult-line()
;;   (interactive)
;;   (consult-line (exec/thing-at-point) 0))

(defun exec/thing-at-point()
  (interactive)
  (if (region-active-p)
	  (buffer-substring-no-properties (region-beginning) (region-end))
    (let ((bounds (bounds-of-thing-at-point 'symbol)))
	  (if bounds
		  (buffer-substring-no-properties (car bounds) (cdr bounds))
        nil))))

;; define C-x f to consult-recent-file
(general-define-key
 "C-x C-r" 'consult-recent-file
 "C-x C-f" 'find-file
 "C-x C-d" 'exec/dired-current-directory
 "C-x d" 'list-directory
 "C-S-f" ;; 'exec/color-rg-search-project
 'consult-ripgrep

 "H-f" '(lambda()
		  (interactive)
		  ;; if vterm-buffer-name variable is not set, eval (vterm) and return
		  (if (not (bound-and-true-p vterm-buffer-name))
			  (vterm)
			(if (equal (buffer-name) vterm-buffer-name)
				(switch-to-buffer (other-buffer))
			  (vterm))))

 "H-d" 'describe-char

 "H-p" '(nil :which-key "package? profiler?")
 "H-p 1" '(lambda()
			(interactive)
			(profiler-start 'cpu+mem))
 "H-p 2" '(lambda()
			(interactive)
			(profiler-stop)
			(profiler-report)
			)
 "H-p m" 'mu4e-search-bookmark
 "H-p n" 'exec/ncmpcpp
 "H-p l" 'clm/toggle-command-log-buffer

 "H-b H-b" 'blink-search

 "H-s" 'color-rg-search-symbol-in-current-file

 "H-]" 'persp-next
 "H-[" 'persp-prev

 "H-g H-g" 'magit-status
 "H-g H-l" 'magit-log-all

 "H-<return>" 'eval-last-sexp

 "C-S-<mouse-1>" nil
 )







(setq default-directory "~")

(add-hook 'emacs-startup-hook '(lambda()
								 ;; (treemacs)
								 ;; (dired-sidebar-show-sidebar)

								 (switch-to-buffer "*scratch*")
								 ;; (exec/set-top-priority)
								 ))


(setq
 window-sides-slots '(nil nil nil nil) ;; (left top right bottom)
 window-sides-vertical t
 )


(setq display-buffer-alist nil)

;; (add-to-list 'display-buffer-alist
;; '(
;;   "\\*helpful *"
;;   (display-buffer-in-side-window)
;;   (side . bottom)
;;   (slot . 0)
;;   (dedicated)
;;   )
;; )

;; (add-to-list 'display-buffer-alist
;; 			 '(
;; 			   "\\*info\\* *"
;; 			   (display-buffer-in-side-window)
;; 			   (side . bottom)
;; 			   (slot . 1)
;; 			   ))
;; (add-to-list 'display-buffer-alist
;; 			 '(
;; 			   "\\*Help\\* *"
;; 			   (display-buffer-in-side-window)
;; 			   (side . bottom)
;; 			   (slot . 2)
;; 			   ))

;; (add-to-list 'display-buffer-alist
;; 			 '(
;; 			   "\\*Outline *pdf\\*"
;; 			   (display-buffer-in-side-window)
;; 			   (side . right)
;; 			   (slot . 1)
;; 			   ))

;; (add-to-list 'display-buffer-alist
;; 			 '(
;; 			   "\\*Flycheck errors\\* *"
;; 			   (display-buffer-in-side-window)
;; 			   (side . bottom)
;; 			   (slot . 0)
;; 			   (window-height . 0.3)
;; 			   )
;; 			 )

;; (add-to-list 'display-buffer-alist
;; 			 '(
;; 			   "\\*Warnings\\* *"
;; 			   (display-buffer-in-side-window)
;; 			   (side . bottom)
;; 			   (slot . 0)
;; 			   (window-height . 0.3)
;; 			   )
;; 			 )

;; (add-to-list 'display-buffer-alist
;; 			 '(
;; 			   "\\*Process List\\*"
;; 			   (display-buffer-in-side-window)
;; 			   (side . bottom)
;; 			   (slot . 0)
;; 			   (window-height . 0.2)
;; 			   )
;; 			 )

;; (add-to-list 'display-buffer-alist
;; 			 '(
;; 			   "\\*Messages\\*"
;; 			   (display-buffer-in-side-window)
;; 			   (side . bottom)
;; 			   (slot . 0)
;; 			   (window-height . 0.2)
;; 			   )
;; 			 )
;; (add-to-list 'display-buffer-alist
;; 			 '(
;; 			   "\\*color-rg\\*"
;; 			   (display-buffer-in-side-window)
;; 			   (side . bottom)
;; 			   (slot . 0)
;; 			   (window-height . 0.25)
;; 			   )
;; 			 )


;; (add-to-list 'display-buffer-alist
;; 			 '(
;; 			   "\\*Ilist\\*"
;; 			   (display-buffer-in-side-window)
;; 			   (side . left)
;; 			   (slot . 2)
;; 			   (window-height . 0.3)
;; 			   )
;; 			 )

;; (add-to-list 'display-buffer-alist
;; 			 '("\\*org-roam\\*"
;; 			   (display-buffer-in-side-window)
;; 			   (side . right)
;; 			   (slot . 1)
;; 			   (window-parameters . ((no-other-window . t)
;; 									 (no-delete-other-windows . t)))))

;; (add-to-list 'display-buffer-alist
;; 			 '(
;; 			   "\\*Go-Translate\\*"
;; 			   (display-buffer-in-side-window)
;; 			   (side . bottom)
;; 			   (slot . 4)
;; 			   (window-height . 0.5)
;; 			   )
;; 			 )





(custom-set-faces ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(line-number ((t (:family "Iosevka"
							:foreground "grey"))))

 '(line-number-current-line ((t (
								 :inherit line-number
								 :background "#880000"
								 :foreground "#ffffff"
								 ))))
 '(imenu-list-entry-face ((t (:height 0.8))))

 '(mode-line          ((t (:box nil :background "black" :height 0.9))))
 '(mode-line-inactive ((t (:inherit mode-line))))
 '(mode-line-active   ((t (:inherit mode-line :background "#013220"))))

 '(header-line ((t (:height 0.9 :background "black"))))
 '(minibuffer-prompt-face ((t (:background "red" :foreground "yellow"))))

 '(hl-line-face ((t (
					 :inherit nil
					 :background "gray20"
					 )))
				)

 )

;; change mode-line color based on evil-state variable
(defun exec/reset-evil-state(&rest r)
  (interactive)
  (unless (minibufferp)
	(cond
	 ((equal evil-state 'insert)
	  (set-face-attribute 'mode-line-active nil :background "red" :foreground "white" ))
	 ((equal evil-state 'normal)
	  (set-face-attribute 'mode-line-active nil :background "darkgreen" :foreground "white" ))
	 ((equal evil-state 'visual)
	  (set-face-attribute 'mode-line-active nil :background "purple" :foreground "white" )
	  )
	 ((equal evil-state 'motion)
	  (set-face-attribute 'mode-line-active nil :background "plum3" :foreground "white" ))
	 ((equal evil-state 'replace)
	  (set-face-attribute 'mode-line-active nil :background "orange" :foreground "white" ))
	 ((equal evil-state 'operator)
	  (set-face-attribute 'mode-line-active nil :background "blue" :foreground "white" ))
	 ((equal evil-state 'emacs)
	  (set-face-attribute 'mode-line-active nil :background "yellow" :foreground "black" )))))

(add-hook 'evil-insert-state-entry-hook 'exec/reset-evil-state)
(add-hook 'evil-normal-state-entry-hook 'exec/reset-evil-state)
(add-hook 'evil-visual-state-entry-hook 'exec/reset-evil-state)
(add-hook 'evil-motion-state-entry-hook 'exec/reset-evil-state)
(add-hook 'evil-replace-state-entry-hook 'exec/reset-evil-state)
(add-hook 'evil-operator-state-entry-hook 'exec/reset-evil-state)
(add-hook 'evil-emacs-state-entry-hook 'exec/reset-evil-state)
(add-hook 'evil-emacs-state-exit-hook 'exec/reset-evil-state)


(defun disable-all-themes ()
  "Disable all active themes."
  (dolist (i custom-enabled-themes)
	(disable-theme i))
  )

(defadvice load-theme (before disable-themes-first activate)
  (disable-all-themes))




(use-package vertico
  :straight (:files (:defaults "extensions/*"))
  ;; :hook (vertico-buffer-mode . 'exec/vertico-buffer-mode-hook-func)
  :custom-face
  (vertico-group-title ((t (:foreground "pink" :weight bold))))
  :bind (
		 (:map vertico-map
			   ("?" . minibuffer-completion-help)
			   ("M-RET" . minibuffer-force-complete-and-exit)
			   ("M-TAB" . minibuffer-complete)
			   ("M-j" . vertico-next-group)
			   ("M-k" . vertico-previous-group)
			   )
		 )
  :config
  (setq
   vertico-count 10
   vertico-resize t
   vertico-scroll-margin 7
   vertico-count-format '("%-6s " . "%2s/%5s")
   ;; vertico-buffer-display-action
   ;; '(display-buffer-below-selected (window-height . 10))
   ;; '(display-buffer-below-selected )
   ;; '(display-buffer-in-direction
   ;; 	 ;; (direction . down)
   ;; 	 (window-width . 0.5)
   ;; 	 )
   )

  (setq vertico-cycle t)

  (general-evil-define-key '(normal insert) vertico-map
	"C-j" 'vertico-next
	"C-k" 'vertico-previous
	"C-d" 'vertico-scroll-up
	"C-u" 'vertico-scroll-down
	)

  (vertico-mode)

  (use-package vertico-prescient
	:config
	(vertico-prescient-mode 1)
	;; Configure `prescient.el' filtering to your liking.
	(setq prescient-filter-method '(prefix literal-prefix regexp literal initialism)
		  prescient-use-char-folding t
		  prescient-use-case-folding 'smart
		  prescient-sort-full-matches-first t ; Works well with `initialism'.
		  prescient-sort-length-enable t)

	;; Save recency and frequency rankings to disk, which let them become better
	;; over time.
	(prescient-persist-mode 1))

  ;; Prefix the current candidate with “» ”. From
  ;; https://github.com/minad/vertico/wiki#prefix-current-candidate-with-arrow
  (defun exec/vertico-finger(orig cand prefix suffix index _start)
	(setq cand (funcall orig cand prefix suffix index _start))
	(concat
	 (if (= vertico--index index)
		 (propertize "» " 'face 'vertico-current)
	   "  ")
	 cand))

  (advice-add #'vertico--format-candidate :around 'exec/vertico-finger)
  )


(use-package vertico-posframe
  :config
  (defun exec/vertico-posframe-get-size (buffer)
	"Set the vertico-posframe size according to the current frame."
	(let* (
		   ;; (height (min vertico-posframe-height (buffer-local-value 'vertico--total vertico-posframe--buffer)))
		   (height (+ 1  (min vertico-posframe-height (buffer-local-value 'vertico--total vertico-posframe--buffer))))
		   ;; (min-height (+ 3 (min vertico-posframe-height (buffer-local-value 'vertico--total vertico-posframe--buffer))))
		   (min-height (length vertico--candidates))
		   (width (- (frame-width) 1))
		   )

	  (list
	   :height height
	   :width width
	   :min-height min-height
	   :min-width width)))

  (defun exec/posframe-poshandler-frame-top-center (info)
	"Posframe's position handler.

This poshandler function let top edge center of posframe align
to top edge center of frame.

The structure of INFO can be found in docstring of
`posframe-show'."
	(cons (/ (- (plist-get info :parent-frame-width)
				(plist-get info :posframe-width))
			 2)

		  90))

  (setq
   vertico-posframe-parameters
   '((left-fringe . 0)
	 (right-fringe . 0)
	 (accept-focus . t)
	 (refresh . 1)
	 (alpha . 0.1)
	 )
   vertico-posframe-border-width 1
   vertico-posframe-poshandler 'exec/posframe-poshandler-frame-top-center
   vertico-posframe-width  (- (frame-width) 7)
   vertico-posframe-height (+ 1 vertico-count)
   vertico-posframe-size-function 'vertico-posframe-get-size
   vertico-posframe-font nil
   vertico-posframe-min-height 0
   vertico-flat-max-lines 3)
  (setq vertico-count 10)


  (if (display-graphic-p)
	  (vertico-posframe-mode)
	)
  )



(use-package xref
  :config
  (setq xref-search-program 'ripgrep)
  (setq xref-prompt-for-identifier nil))

(use-package ess)


(use-package calendar
  :config
  (setq calendar-left-margin 1
		calendar-right-margin 1)
  )

;; (setq jit-lock-defer-time 0.25
;; 	  jit-lock-stealth-time 0
;; 	  jit-lock-chunk-size 4096
;; 	  )

(use-package gcmh
  :disabled
  :hook (
		 (emacs-startup . gcmh-mode)
		 (focus-out . garbage-collect)
		 )
  :config
  (setq
   ;; gc-cons-percentage 1.0
   garbage-collection-messages nil
   gcmh-verbose nil
   gcmh-idle-delay 'auto
   gcmh-low-cons-threshold (* 200  1024 1024 1024)
   gcmh-high-cons-threshold (* 400  1024 1024 1024)
   )
  )


(setq native-comp-always-compile t)
(setq native-comp-speed 3)

(use-package autorevert
  :custom ((auto-revert-interval  0.9))
  :config
  (global-auto-revert-mode))

(use-package smartscan
  :config
  )




(use-package evil-easymotion)
(use-package evil-args
  :config

  ;; bind evil-args text objects
  (define-key evil-inner-text-objects-map "a" 'evil-inner-arg)
  (define-key evil-outer-text-objects-map "a" 'evil-outer-arg)

  ;; bind evil-forward/backward-args
  (define-key evil-normal-state-map "L" 'evil-forward-arg)
  (define-key evil-normal-state-map "H" 'evil-backward-arg)
  (define-key evil-motion-state-map "L" 'evil-forward-arg)
  (define-key evil-motion-state-map "H" 'evil-backward-arg)

  ;; bind evil-jump-out-args
  (define-key evil-normal-state-map "K" 'evil-jump-out-args)
  )
(use-package evil-lion
  :config
  ( evil-lion-mode))
(use-package evil-exchange
  :after evil
  :config (evil-exchange-install))

(use-package evil-mc
  :after evil
  :config
  (global-evil-mc-mode))
(use-package evil-commentary
  :after evil
  :config
  (evil-commentary-mode))
(use-package evil-visualstar
  :custom
  (evil-visualstar/persistent  t)
  :config
  (global-evil-visualstar-mode))
(use-package evil-surround
  :after evil
  :custom (evil-surround-pairs-alist  '((40 "( " . " )")
										(91 "[ " . " ]")
										(123 "{ " . " }")
										(41 "(" . ")")
										(93 "[" . "]")
										(125 "{" . "}")
										(35 "#{" . "}")
										(98 "(" . ")")
										(66 "{" . "}")
										(62 "<" . ">")
										(116 . evil-surround-read-tag)
										(60 . evil-surround-read-tag)
										(102 . evil-surround-function)
										(61 " =" . "= ")
										(60 "<" . ">")))
  :config
  (global-evil-surround-mode))
(use-package evil-terminal-cursor-changer
  :config (evil-terminal-cursor-changer-activate) ; or (etcc-on)
  )
(use-package evil-goggles
  :config
  ;; (setq evil-goggles-duration 0.100)
  ;; (evil-goggles-use-diff-faces)
  ;; (evil-goggles-mode)
  )
(use-package better-jumper
  :disabled
  :after evil
  :config
  ;; (define-key evil-motion-state-map (kbd "C-o") 'better-jumper-jump-backward)
  ;; (define-key evil-motion-state-map (kbd "C-i") 'better-jumper-jump-forward)
  ;; (setq better-jumper-context 'window)
  ;; (setq better-jumper-add-jump-behavior 'append)
  ;; (setq better-jumper-use-evil-jump-advice t)
  ;; (setq better-jumper-max-length 100)
  ;; (setq better-jumper-use-savehist nil)
  ;; (better-jumper-mode)
  )

(use-package transient-dwim
  ;; :bind ("M-=" . transient-dwim-dispatch)
  )

(use-package transient-posframe
  :config
  (setq transient-posframe-min-width 80
		transient-posframe-min-height 30)
  (transient-posframe-mode ))

(use-package man
  :config
  (setq Man-width nil)
  (setq Man-width-max nil)
  (setq Man-notify-method 'pushy)
  (set-face-attribute 'Man-overstrike nil :inherit 'bold :foreground "orange red")
  (set-face-attribute 'Man-underline nil :inherit 'underline :foreground "forest green")
  )

(use-package zig-mode
  :config
  )

;; (use-package info
;;   :config
;;   (defun niceify-info nil
;; 	"Highlight function, variable, macro, etc. description headers
;; in Info with arbitrary faces."
;; 	(let ((type-face 'italic)
;; 		  (name-face 'bold)
;; 		  (args-face 'italic)
;; 		  (what-it-was inhibit-read-only))
;; 	  (unwind-protect
;; 		  (let (from to line-start)
;; 			(setq inhibit-read-only t)
;; 			(save-match-data
;; 			  (save-excursion
;; 				(beginning-of-buffer)
;; 				(while (re-search-forward "^ -- " nil t)
;; 				  (save-excursion
;; 					(beginning-of-line)
;; 					(setq line-start (point)))

;; 				  (setq from (point))
;; 				  (re-search-forward ":" nil t)
;; 				  (setq to (point))
;; 				  (add-face-text-property from to type-face)

;; 				  (re-search-forward " " nil t)
;; 				  (setq from (point))
;; 				  (re-search-forward " " nil t)
;; 				  (setq to (point))
;; 				  (add-face-text-property from to name-face)

;; 				  (setq from (point))
;; 				  (end-of-line)
;; 				  (add-face-text-property from (point) args-face)))))
;; 		(set-buffer-modified-p nil)
;; 		(setq inhibit-read-only what-it-was))))

;;   ;; apply this function whenever an info page is selected
;;   (add-hook 'Info-selection-hook
;; 			#'niceify-info)
;;   )


(use-package avy
  :bind (("C-S-j"  . avy-goto-char-2-below)
		 ("C-S-k"  . avy-goto-char-2-above)))
(use-package elfeed

  :config
  ;; Somewhere in your .emacs file
  (setq elfeed-feeds
		'("http://nullprogram.com/feed/"
		  "https://planet.emacslife.com/atom.xml"
		  "https://www.reddit.com/.rss"
		  "https://hnrss.org/bestcomments"
		  "https://hnrss.org/newest?points=300"
		  "https://hnrss.org/newest?comments=250"
		  "https://goodnews.eu/en/feed/"
		  "https://www.btcstudy.org/atom.xml"
		  "https://hwv430.blogspot.com/feeds/posts/default"
		  ))
  (use-package elfeed-dashboard)
  )

(add-hook 'prog-mode-hook 'electric-pair-local-mode)
(add-hook 'prog-mode-hook 'electric-indent-mode)
(add-hook 'minibuffer-mode-hook 'electric-pair-local-mode)
(add-hook 'cider-repl-mode-hook 'electric-pair-local-mode)

(defun read-file (filename)
  (save-excursion (let ((new (get-buffer-create filename))
						(current (current-buffer)))
					(switch-to-buffer new)
					(insert-file-contents filename)
					(mark-whole-buffer)
					(let ((contents
						   (buffer-substring
							(mark)
							(point)
							)))
					  (kill-buffer new)
					  (switch-to-buffer current) contents)))
  )


(use-package devdocs-browser)
(use-package webpaste
  :bind (("C-c C-p C-b" . webpaste-paste-buffer)
		 ("C-c C-p C-r" . webpaste-paste-region)
		 ("C-c C-p C-p" . webpaste-paste-buffer-or-region))
  :config
  (progn
	(setq webpaste-provider-priority '("ix.io" )))
  )


(use-package flycheck
  :custom
  (flycheck-disabled-checkers '(rust rust-cargo))
  (flycheck-set-indication-mode 'left-fringe)

  :config
  (setq-default flycheck-display-errors-delay 0
				flycheck-idle-change-delay 0.2
				flycheck-checker-error-threshold 800
				flycheck-rust-executable "cargo-clippy")

  ;; flycheck err cycle
  ;; Optional: ensure flycheck cycles, both when going backward and forward.
  ;; Tries to handle arguments correctly.
  ;; Since flycheck-previous-error is written in terms of flycheck-next-error,
  ;; advising the latter is enough.
  (defun flycheck-next-error-loop-advice (orig-fun &optional n reset)
										; (message "flycheck-next-error called with args %S %S" n reset)
	(condition-case err
		(apply orig-fun (list n reset))
	  ((user-error)
	   (let ((error-count (length flycheck-current-errors)))
		 (if (and
			  (> error-count 0)                   ; There are errors so we can cycle.
			  (equal (error-message-string err) "No more Flycheck errors"))
			 ;; We need to cycle.
			 (let* ((req-n (if (numberp n) n 1)) ; Requested displacement.
										; An universal argument is taken as reset, so shouldn't fail.
					(curr-pos (if (> req-n 0) (- error-count 1) 0)) ; 0-indexed.
					(next-pos (mod (+ curr-pos req-n) error-count))) ; next-pos must be 1-indexed
										; (message "error-count %S; req-n %S; curr-pos %S; next-pos %S" error-count req-n curr-pos next-pos)
										; orig-fun is flycheck-next-error (but without advise)
										; Argument to flycheck-next-error must be 1-based.
			   (apply orig-fun (list (+ 1 next-pos) 'reset)))
		   (signal (car err) (cdr err)))))))

  (advice-add 'flycheck-next-error :around #'flycheck-next-error-loop-advice)


  (global-flycheck-mode)


  (use-package flycheck-posframe
	:hook
	(flycheck-mode . flycheck-posframe-mode)
	:custom-face
	(flycheck-posframe-face ((t (:height 0.8))))
	(flycheck-posframe-background-face ((t (:height 0.8))))
	:config
	(setq-default
	 flycheck-posframe-position 'window-top-left-corner
	 flycheck-posframe-border-use-error-face nil
	 flycheck-posframe-border-width 1
	 flycheck-posframe-info-prefix "💬 "
	 flycheck-posframe-warning-prefix "⚠️ "
	 flycheck-posframe-error-prefix "❌ "))

  (use-package flycheck-status-emoji
	:hook
	(flycheck-mode . flycheck-status-emoji-mode))

  (use-package flycheck-aspell
	:after (flycheck ispell)
	:custom
	(ispell-dictionary  "en_US")
	(ispell-program-name  "aspell")
	(ispell-silently-savep  t)
	(ispell-extra-args  '("--sug-mode=ultra" "--lang=en_US")))


  (use-package flycheck-color-mode-line
	:hook (flycheck-mode . flycheck-color-mode-line-mode)))

(use-package attrap
  :bind ("C-x /" . attrap-attrap))

(use-package ispell
  :config
  ;; (ispell-minor-mode)
  )

(use-package jinx
  :straight (:type built-in)
  ;; :hook
  ;; (emacs-startup . global-jinx-mode)
  :bind
  ([remap ispell-word] . jinx-correct)
  :config
  )

(use-package sudo-edit
  :straight (sudo-edit :type git :host github :repo "nflath/sudo-edit")
  :config
  (sudo-edit-indicator-mode)
  )

(use-package nix-mode)


(defun exec/set-top-priority()
  (interactive)
  ;; use renice to set the priority of the current process to -20, this command need sudo privilidge
  (shell-command (concat "echo " (shell-quote-argument (read-passwd "renice command need sudo password: "))
						 " | sudo -S renice -n -20 $(pidof emacs)"))
  )

(defun exec/toggle-transparency ()
  (interactive)
  (let ((alpha (frame-parameter nil 'alpha)))
	(set-frame-parameter
	 nil 'alpha
	 (if (eql (cond ((numberp alpha) alpha)
					((numberp (cdr alpha)) (cdr alpha))
					;; Also handle undocumented (<active> <inactive>) form.
					((numberp (cadr alpha)) (cadr alpha)))
			  100)
		 '(15 . 50) '(100 . 100)))))


(use-package diff-hl
  :config
  (setq diff-hl-flydiff-delay 0.2
		diff-hl-ask-before-revert-hunk nil)
  (custom-set-faces
   '(diff-hl-insert ((t (:background "dark green" :foreground "dark green"))))
   '(diff-hl-change ((t (:background "orange" :foreground "orange"))))
   '(diff-hl-delete ((t (:background "red" :foreground "red"))))
   )
  ;; test
  ;; test
  ;; test
  (add-hook 'magit-pre-refresh-hook 'diff-hl-magit-pre-refresh)
  (add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh)
  (add-hook 'focus-in-hook 'diff-hl-update)

  (diff-hl-margin-mode)
  (diff-hl-flydiff-mode)
  (global-diff-hl-mode)
  (global-diff-hl-show-hunk-mouse-mode)
  )
(use-package highlight-numbers
  :hook (prog-mode . highlight-numbers-mode))

(use-package highlight)

(use-package highlight-escape-sequences
  :hook (prog-mode . hes-mode))

(use-package valign
  :disabled t
  :hook
  ;; (org-mode . valign-mode)
  )

(use-package symbol-overlay
  :config
  (symbol-overlay-mode)
  )



(defun exec/put-file-name-on-clipboard ()
  "Put the current file name on the clipboard"
  (interactive)
  (let ((filename (if (equal major-mode 'dired-mode) default-directory (buffer-file-name))))
	(when filename (with-temp-buffer (insert filename)
									 (clipboard-kill-region (point-min)
															(point-max)))
		  (message filename))) )


(use-package elisp-refs)

(defun print-elements-of-list (list)
  "Print each element of LIST on a line of its own."
  (while list
	(print (car list))
	(setq list (cdr list))))

(use-package toml-mode
  :config
  )
(use-package yaml-mode)
(use-package json-mode)
(use-package ssh-config-mode)


(use-package quickrun
  :bind (
		 ("C-c q" . quickrun)
		 )
  :config
  (setq quickrun-focus-p t
		quickrun-debug t)
  )



(use-package prescient
  :config
  (prescient-persist-mode))

(use-package esup
  :config
  )

(use-package flx)

(use-package posframe
  :config
  )
(use-package exwm
  :config
  ;; exwm
  )

(use-package bongo
  :general
  (:keymaps 'bongo-library-mode-map "RET" 'bongo-play-line)
  (:keymaps 'bongo-playlist-mode-map "RET" 'bongo-play-line)
  :config
  (setq
   bongo-enabled-backends '(mpv vlc)
   bongo-default-directory "~/Music"
   )
  )
(use-package mpdel
  :hook
  (mpc-songs-mode . (lambda() (interactive) (tab-line-mode -1)))
  (mpc-status-mode . (lambda() (interactive) (tab-line-mode -1)))
  (mpc-tagbrowser-mode . (lambda() (interactive) (tab-line-mode -1)))
  :config
  (setq-default mpc-songs-format
				"%2{Disc--}%3{Track} %-5{Time} %65{Title} %20{Album} %20{Artist} %-5{Date}")
  )

(use-package mingus
  :config
  (evil-set-initial-state 'mingus-playlist-mode 'emacs)
  (evil-set-initial-state 'mingus-browse-mode 'emacs)
  (evil-set-initial-state 'mingus-help-mode 'emacs)
  )

(evil-set-initial-state 'xwidget-webkit-mode 'emacs)

(defun exec/ncmpcpp()
  (interactive)
  ;; open vterm, and execute `ncmpcpp' command, rename the buffer to "*ncmpcpp*", if we have "*ncmpcpp*" buffer already, open the buffer.

  (if (get-buffer "*🎵ncmpcpp🎵*")
	  (switch-to-buffer "*🎵ncmpcpp🎵*")
	(vterm "*🎵ncmpcpp🎵*")
	(vterm-send-string "ncmpcpp")
	(vterm-send-return))
  (delete-other-windows)
  )

(use-package disable-mouse
  :config
  ;; (mapc #'disable-mouse-in-keymap
  ;; 		(list evil-motion-state-map
  ;; 			  evil-normal-state-map
  ;; 			  evil-visual-state-map
  ;; 			  evil-insert-state-map))
  ;; (global-disable-mouse-mode)
  )


(use-package helm
  :disabled
  :bind (
		 ("C-c h" . helm-command-prefix)
		 ("M-x" . helm-M-x)
		 ("C-x C-f" . helm-find-files)
		 ("C-x b" . helm-buffers-list)
		 ("C-x r b" . helm-filtered-bookmarks)
		 ("C-x r l" . helm-bookmarks)

		 ("M-s o" . helm-occur)
		 )
  :config
  (setq helm-M-x-fuzzy-match t
		helm-M-x-always-save-history t
		helm-M-x-reverse-history nil
		helm-M-x-show-short-doc t
		helm-buffers-fuzzy-matching t)

  (setq helm-follow-mode-persistent t)

  (setq helm-display-function  'helm-default-display-buffer)

  (setq helm-buffer-max-length 10)
  (setq helm-display-buffer-height 10)
  (setq helm-always-two-windows nil
		helm-split-window-inside-p t
		helm-buffers-show-icons t
		)

  (setq helm-autoresize-max-height 30
		helm-autoresize-min-height 1
		)

  (use-package helm-wikipedia)

  (use-package helm-xref
	:disabled t
	)

  (use-package helm-flx
	:config
	(setq helm-flx-for-helm-find-files t ;; t by default
		  helm-flx-for-helm-locate t) ;; nil by default
	(helm-flx-mode)
	)

  (use-package helm-describe-modes)
  (use-package helm-descbinds)
  (use-package helm-ag)

  (use-package helm-projectile)

  (use-package helm-posframe
	:config
	(setq helm-posframe-height 30
		  helm-posframe-width 1000
		  helm-posframe-parameters '((left-fringe . 0) (right-fringe . 0)))
	(helm-posframe-enable)
	)

  (use-package helm-themes)

  (use-package helm-taskswitch
	;; should bind a key in X11 to: emacsclient -n -e '(helm-taskswitch)'
	)

  (use-package helm-icons
	:config
	(setq helm-icons-provider 'all-the-icons)
	(helm-icons-enable)
	)

  (use-package helm-ls-git
	:bind (
		   ("C-x C-d" . helm-browse-project)
		   ("C-x r p" . helm-projects-history)
		   )
	)
  (helm-mode)
  (helm-autoresize-mode)
  )



;; (defun exec/vertico-buffer-mode-hook-func()
;;   (interactive)
;;   (setq-local buffer-face-mode-face '(
;; 								:height 0.8
;; 								))
;;   (buffer-face-mode)
;;   )


(use-package mini-frame
  :config
  (setq mini-frame-color-shift-step 0
		mini-frame-internal-border-color "cyan"
		mini-frame-ignore-commands
		'(eval-expression
		  "edebug-eval-expression"
		  debugger-eval-expression
		  evil-ex
		  evil-ex-search-forward
		  )
		mini-frame-resize t
		mini-frame-resize-min-height 2
		mini-frame-resize-max-height 10
		mini-frame-ignore-functions '(exec/set-top-priority)
		mini-frame-show-parameters '(
									 (left . 0.5)
									 (height . 0.33)
									 (width . 0.99)
									 (top . 0.94)
									 )
		)

  (custom-set-faces '(child-frame-border
					  ((t (:background "green")))))

										; (mini-frame-mode)
  )


(use-package embark
  :bind
  (("H-." . embark-act)         ;; pick some comfortable binding
   ("H-;" . embark-dwim)        ;; good alternative: M-.
   ("H-h B" . embark-bindings)) ;; alternative for `describe-bindings'
  :hook
  (embark-collect . exec/decrease-buffer-font)
  :init
  ;; (general-evil-define-key 'normal 'global "C-." 'embark-act)
  ;; (global-set-key (kbd "C-h B") 'embark-bindings)

  ;; Optionally replace the key help with a completing-read interface
  (setq prefix-help-command #'embark-prefix-help-command)

  ;; Show the Embark target at point via Eldoc.  You may adjust the Eldoc
  ;; strategy, if you want to see the documentation from multiple providers.
  ;; (add-hook 'eldoc-documentation-functions #'embark-eldoc-first-target)
  ;; (setq eldoc-documentation-strategy #'eldoc-documentation-compose-eagerly)

  :config
  ;; Hide the mode line of the Embark live/completions buffers
  ;; (setq embark-indicators nil)
  (setq embark-mixed-indicator-delay 0)

  (add-to-list 'display-buffer-alist
			   '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none))))
  )

(use-package embark-consult
  :after consult
  :hook
  (embark-collect-mode . consult-preview-at-point-mode)
  )


(use-package marginalia
  :after vertico
  ;; Either bind `marginalia-cycle` globally or only in the minibuffer
  :bind (
		 ("M-A" . marginalia-cycle)
		 (:map minibuffer-local-map
			   ("M-A" . marginalia-cycle))
		 )

  ;; The :init configuration is always executed (Not lazy!)
  ;; Must be in the :init section of use-package such that the mode gets
  ;; enabled right away. Note that this forces loading the package.
  :init
  (marginalia-mode 1)
  :config
  (setopt marginalia-align 'right
		  marginalia-separator "|")
  (add-to-list 'marginalia-annotator-registry '(project-buffer marginalia-annotate-project-buffer))
  (add-to-list 'marginalia-annotator-registry '(consult-projectile-switch-to-buffer marginalia-annotate-project-buffer))
  (add-to-list 'marginalia-annotator-registry '(consult-projectile-find-file marginalia-annotate-file))

  )

(use-package nerd-icons-completion
  :init
  (setq-default
   nerd-icons--cache-limit 12048
   nerd-icons-font-family "Symbols Nerd Font Mono"
   )
  :config
  (nerd-icons-completion-mode)

  (add-hook 'marginalia-mode-hook #'nerd-icons-completion-marginalia-setup))

(use-package nerd-icons-dired
  :hook
  (dired-mode . nerd-icons-dired-mode))

(use-package ctrlf)

(use-package popper
  :ensure t ; or :straight t
  :bind (("C-`"   . popper-toggle)
         ("M-`"   . popper-cycle)
         ("C-M-`" . popper-toggle-type))
  :init
  (setq popper-reference-buffers
        '("\\*Messages\\*"
		  "Output\\*$"
		  "\\*Async Shell Command\\*"
		  help-mode
		  helpful-mode
		  compilation-mode)
		popper-display-control nil
		popper-window-height nil)

  (popper-mode +1)
  (popper-echo-mode +1)

  ;; (add-hook 'compilation-mode-hook 'exec/decrease-buffer-font)
  ;; (add-hook 'helpful-mode-hook 'exec/decrease-buffer-font)
  ;; (add-hook 'messages-buffer-mode-hook 'exec/decrease-buffer-font)
  )



(use-package orderless
  :disabled t
  :init
  (setq completion-search-distance 200)
  (setq completion-styles '(
							;; partial-completion
							;; substring
							;; flex
							;; basic
							;; orderless
							;; emacs22
							)
		completion-category-defaults nil
		completion-category-overrides '((file (styles basic partial-completion)))
		)
  )


(use-package copilot
  :ensure nil
  :straight (copilot :type git :host github :repo "zerolfx/copilot.el" :files ("*.el" "dist"))
  ;; :bind (:map copilot-completion-map
  ;; 			  ("<tab>" . 'copilot-accept-completion)
  ;; 			  ("TAB" . 'copilot-accept-completion)
  ;; 			  ("C-TAB" . 'copilot-accept-completion-by-word)
  ;; 			  ("C-<tab>" . 'copilot-accept-completion-by-word))
  :config (setq copilot-node-executable "node"
				copilot-idle-delay 1
				copilot-max-char -1
				copilot-indent-warning-suppress t
				)
  (custom-set-faces '(copilot-overlay-face ((t (:inherit shadow :underline t :weight thin :slant italic :foreground "white")))))
  (defun exec/add-copilot-hook()
	(add-hook 'prog-mode-hook  'copilot-mode)
	(add-hook 'org-mode  'copilot-mode)
	(add-hook 'text-mode 'copilot-mode)
	)

  (add-hook 'after-init-hook 'exec/add-copilot-hook)

  (general-def copilot-completion-map
	"<tab>"       'copilot-accept-completion
	"C-/"         'copilot-next-completion
	"C-f"         'copilot-accept-completion-by-line
	"M-f"         'copilot-accept-completion-by-word
	"C-<escape>" 'copilot-clear-overlay
	)
  )

(use-package gptai
  :config
  (setq
   gptai-model "text-davinci-003"
   gptai-api-key (with-temp-buffer
				   (insert-file-contents "~/.config/openai_api_key/key.private")
				   (buffer-substring-no-properties (point-min) (line-end-position)))
   gptai-max-tokens 1000
   )
  ;; (gptai-list-models)
  )
;; (evil-line-move 1)


;; (use-package chatgpt
;;   :config
;;   (setenv "OPENAI_API_KEY"
;; 		  (with-temp-buffer
;; 			(insert-file-contents "~/.config/openai_api_key/key.private")
;; 			(buffer-substring-no-properties (point-min) (line-end-position)))

;; 		  )
;;   )

(use-package corfu
  :straight (:files (:defaults "extensions/*"))
  :bind
  (:map corfu-map
		("C-j" . corfu-next)
		("C-k" . corfu-previous)
		("C-f" . corfu-scroll-up)
		("C-b" . corfu-scroll-down)
		([tab] . exec/tab-in-insert-mode-command)
		("<f9>" . corfu-quit)
		)

  :config
  (setq
   corfu-auto t
   corfu-auto-prefix 1
   corfu-cycle t
   corfu-preselect-first nil
   corfu-count 20
   corfu-auto-delay 0.2
   corfu-quit-no-match t
   corfu-quit-at-boundary t
   corfu-on-exact-match nil
   corfu-max-width 120
   corfu-min-width 10
   corfu-bar-width 2
   corfu-popupinfo-hide nil
   corfu-popupinfo-delay '(0.0 . 0.0)
   corfu-popupinfo-max-height 100
   corfu-preview-current nil)


  (global-corfu-mode)
  (corfu-popupinfo-mode)
  (corfu-popupinfo-mode -1)
  (defun exec/corfu-move-to-minibuffer ()
	(interactive)
	(when completion-in-region--data
	  (let ((completion-extra-properties corfu--extra)
			completion-cycle-threshold completion-cycling)
		(apply #'consult-completion-in-region completion-in-region--data))))
  (keymap-set corfu-map "M-m" #'exec/corfu-move-to-minibuffer)
  (add-to-list 'corfu-continue-commands #'exec/corfu-move-to-minibuffer)

  (defun exec/corfu-enable-in-minibuffer ()
	"Enable Corfu in the minibuffer if `completion-at-point' is bound."
	(when (where-is-internal #'completion-at-point (list (current-local-map)))
	  ;; (setq-local corfu-auto nil) ;; Enable/disable auto completion
	  (setq-local corfu-echo-delay nil ;; Disable automatic echo and popup
				  corfu-popupinfo-delay nil)
	  (corfu-mode 1)))
  (add-hook 'minibuffer-setup-hook #'exec/corfu-enable-in-minibuffer)
  )

(use-package corfu-prescient
  :config
  (setq corfu-prescient-completion-styles '(basic prescient))
  (corfu-prescient-mode)
  )

(use-package corfu-terminal
  :config

  (unless (display-graphic-p)
	(corfu-terminal-mode))
  )

(use-package eldoc-box
  :config
  (eldoc-box-hover-mode 1)
  (eldoc-box-hover-at-point-mode 1)
  )


(use-package kind-icon
  :after corfu
  :custom
  (kind-icon-default-face nil) ; to compute blended backgrounds correctly

  :config
  (setq kind-icon-use-icons nil)
  (setq kind-icon-mapping
		`(
		  (array ,(nerd-icons-codicon "nf-cod-symbol_array") :face font-lock-type-face)
		  (boolean ,(nerd-icons-codicon "nf-cod-symbol_boolean") :face font-lock-builtin-face)
		  (class ,(nerd-icons-codicon "nf-cod-symbol_class") :face font-lock-type-face)
		  (color ,(nerd-icons-codicon "nf-cod-symbol_color") :face success)
		  (command ,(nerd-icons-codicon "nf-cod-terminal") :face default)
		  (constant ,(nerd-icons-codicon "nf-cod-symbol_constant") :face font-lock-constant-face)
		  (constructor ,(nerd-icons-codicon "nf-cod-triangle_right") :face font-lock-function-name-face)
		  (enummember ,(nerd-icons-codicon "nf-cod-symbol_enum_member") :face font-lock-builtin-face)
		  (enum-member ,(nerd-icons-codicon "nf-cod-symbol_enum_member") :face font-lock-builtin-face)
		  (enum ,(nerd-icons-codicon "nf-cod-symbol_enum") :face font-lock-builtin-face)
		  (event ,(nerd-icons-codicon "nf-cod-symbol_event") :face font-lock-warning-face)
		  (field ,(nerd-icons-codicon "nf-cod-symbol_field") :face font-lock-variable-name-face)
		  (file ,(nerd-icons-codicon "nf-cod-symbol_file") :face font-lock-string-face)
		  (folder ,(nerd-icons-codicon "nf-cod-folder") :face font-lock-doc-face)
		  (interface ,(nerd-icons-codicon "nf-cod-symbol_interface") :face font-lock-type-face)
		  (keyword ,(nerd-icons-codicon "nf-cod-symbol_keyword") :face font-lock-keyword-face)
		  (macro ,(nerd-icons-codicon "nf-cod-symbol_misc") :face font-lock-keyword-face)
		  (magic ,(nerd-icons-codicon "nf-cod-wand") :face font-lock-builtin-face)
		  (method ,(nerd-icons-codicon "nf-cod-symbol_method") :face font-lock-function-name-face)
		  (function ,(nerd-icons-codicon "nf-cod-symbol_method") :face font-lock-function-name-face)
		  (module ,(nerd-icons-codicon "nf-cod-file_submodule") :face font-lock-preprocessor-face)
		  (numeric ,(nerd-icons-codicon "nf-cod-symbol_numeric") :face font-lock-builtin-face)
		  (operator ,(nerd-icons-codicon "nf-cod-symbol_operator") :face font-lock-comment-delimiter-face)
		  (param ,(nerd-icons-codicon "nf-cod-symbol_parameter") :face default)
		  (property ,(nerd-icons-codicon "nf-cod-symbol_property") :face font-lock-variable-name-face)
		  (reference ,(nerd-icons-codicon "nf-cod-references") :face font-lock-variable-name-face)
		  (snippet ,(nerd-icons-codicon "nf-cod-symbol_snippet") :face font-lock-string-face)
		  (string ,(nerd-icons-codicon "nf-cod-symbol_string") :face font-lock-string-face)
		  (struct ,(nerd-icons-codicon "nf-cod-symbol_structure") :face font-lock-variable-name-face)
		  (text ,(nerd-icons-codicon "nf-cod-text_size") :face font-lock-doc-face)
		  (typeparameter ,(nerd-icons-codicon "nf-cod-list_unordered") :face font-lock-type-face)
		  (type-parameter ,(nerd-icons-codicon "nf-cod-list_unordered") :face font-lock-type-face)
		  (unit ,(nerd-icons-codicon "nf-cod-symbol_ruler") :face font-lock-constant-face)
		  (value ,(nerd-icons-codicon "nf-cod-symbol_field") :face font-lock-builtin-face)
		  (variable ,(nerd-icons-codicon "nf-cod-symbol_variable") :face font-lock-variable-name-face)
		  (t ,(nerd-icons-codicon "nf-cod-code") :face font-lock-warning-face)))




  ;; (setq kind-icon-default-face 'corfu-default) ; to compute blended backgrounds correctly
  (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter)
  )

;; (use-package all-the-icons-completion
;;   :config
;;   (all-the-icons-completion-mode))

(use-package cape
  :config
  ;; Add `completion-at-point-functions', used by `completion-at-point'.
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-to-list 'completion-at-point-functions #'cape-file)
  ;; (add-to-list 'completion-at-point-functions #'cape-history)
  ;; (add-to-list 'completion-at-point-functions #'cape-keyword)
  ;; (add-to-list 'completion-at-point-functions #'cape-tex)
  ;; (add-to-list 'completion-at-point-functions #'cape-sgml)
  ;; (add-to-list 'completion-at-point-functions #'cape-rfc1345)
  ;; (add-to-list 'completion-at-point-functions #'cape-abbrev)
  ;; (add-to-list 'completion-at-point-functions #'cape-ispell)
  ;; (add-to-list 'completion-at-point-functions #'cape-dict)
  ;; (add-to-list 'completion-at-point-functions #'cape-symbol)
  ;; (add-to-list 'completion-at-point-functions #'cape-line)

  (setq cape-dabbrev-min-length 0
		cape-dabbrev-check-other-buffers nil)
  (use-package yasnippet-capf
	:straight (:host github :repo "elken/yasnippet-capf")
	:config
	(add-to-list 'completion-at-point-functions #'yasnippet-capf)
	)
  )


;; Use Dabbrev with Corfu!
(use-package dabbrev
  ;; Swap M-/ and C-M-/
  :bind (("M-/" . dabbrev-completion)
         ("C-M-/" . dabbrev-expand))
  ;; Other useful Dabbrev configurations.
  :custom
  (dabbrev-ignored-buffer-regexps '("\\.\\(?:pdf\\|jpe?g\\|png\\)\\'"))
  :config
  (setq dabbrev-upcase-means-case-search t)
  )

(use-package rg
  :hook (rg-mode . (lambda()
					 (switch-to-buffer-other-window (current-buffer))
					 ))
  :config
  (general-nmap :keymaps 'rg-mode-map
	"j" 'compilation-next-error
	"k" 'compilation-previous-error
	)

  (setq rg-executable "rg")
  (setq rg-keymap-prefix (kbd "H-r"))
  (setq rg-show-columns nil)
  (setq rg-show-header t
		rg-hide-command nil)
  (rg-enable-default-bindings)
  (rg-enable-menu)

  (rg-define-search rg-search-current-file
	"Run ripgrep on current file searching"
	:dir current
	:query ask
	:format literal
	:files (rg-get-buffer-file-name)
	:dir current)
  )

(use-package wgrep)

(use-package ripgrep)

;; Example configuration for Consult

(use-package consult
  ;; Replace bindings. Lazily loaded due by `use-package'.
  :bind (;; C-c bindings (mode-specific-map)
		 ("C-c c r" . consult-recent-file)
		 ("C-c c h" . consult-history)
		 ("C-c M-x" . consult-mode-command)
		 ("C-c c k" . consult-kmacro)
		 ;; C-x bindings (ctl-x-map)
		 ("C-x M-:" . consult-complex-command)     ;; orig. repeat-complex-command
		 ("C-x b" . consult-buffer)                ;; orig. switch-to-buffer
		 ("C-x 4 b" . consult-buffer-other-window) ;; orig. switch-to-buffer-other-window
		 ("C-x 5 b" . consult-buffer-other-frame)  ;; orig. switch-to-buffer-other-frame
		 ("C-x r b" . consult-bookmark)            ;; orig. bookmark-jump
		 ("C-x p b" . consult-project-buffer)      ;; orig. project-switch-to-buffer
		 ;; Custom M-# bindings for fast register access
		 ("M-#" . consult-register-load)
		 ("M-'" . consult-register-store)          ;; orig. abbrev-prefix-mark (unrelated)
		 ("C-M-#" . consult-register)
		 ;; Other custom bindings
		 ("M-y" . consult-yank-pop)                ;; orig. yank-pop
		 ;; ("<help> a" . consult-apropos)            ;; orig. apropos-command
		 ;; M-g bindings (goto-map)
		 ("M-g e" . consult-compile-error)
		 ("M-g f" . consult-grep)               ;; Alternative: consult-flycheck
		 ("M-g g" . consult-goto-line)             ;; orig. goto-line
		 ("M-g M-g" . consult-goto-line)           ;; orig. goto-line
		 ("M-g o" . consult-outline)               ;; Alternative: consult-org-heading
		 ("M-g m" . consult-mark)
		 ("M-g k" . consult-global-mark)
		 ("M-g i" . consult-imenu)
		 ("M-g i" . consult-imenu-multi)
		 ;; M-s bindings (search-map)
		 ("M-s f" . affe-find)
		 ("M-s D" . consult-locate)
		 ("M-s G" . consult-git-grep)
		 ("M-s r" . consult-ripgrep)
		 ("M-s l" . consult-line)
		 ("M-s L" . consult-line-multi)
		 ("M-s m" . consult-multi-occur)
		 ("M-s k" . consult-keep-lines)
		 ("M-s u" . consult-focus-lines)
		 ;; Isearch integration
		 ("M-s e" . consult-isearch-history)
		 ;; Consult
		 ;; ("M-c r" . consult-recent-file)
		 (:map isearch-mode-map
			   ("M-e" . consult-isearch-history)         ;; orig. isearch-edit-string
			   ("M-s e" . consult-isearch-history)       ;; orig. isearch-edit-string
			   ("M-s l" . consult-line)                  ;; needed by consult-line to detect isearch
			   ("M-s L" . consult-line-multi))            ;; needed by consult-line to detect isearch
		 ;; Minibuffer history
		 (:map minibuffer-local-map
			   ("M-s" . consult-history)                 ;; orig. next-matching-history-element
			   ("M-r" . consult-history)))                ;; orig. previous-matching-history-element

  ;; Enable automatic preview at point in the *Completions* buffer. This is
  ;; relevant when you use the default completion UI.

  ;; The :init configuration is always executed (Not lazy)
  :init

  ;; Optionally configure the register formatting. This improves the register
  ;; preview for `consult-register', `consult-register-load',
  ;; `consult-register-store' and the Emacs built-ins.
  (setq register-preview-delay 1.0
		register-preview-function #'consult-register-format)

  ;; Optionally tweak the register preview window.
  ;; This adds thin lines, sorting and hides the mode line of the window.
  (advice-add #'register-preview :override #'consult-register-window)

  ;; Use Consult to select xref locations with preview
  (setq xref-show-xrefs-function #'consult-xref
		xref-show-definitions-function #'consult-xref)

  ;; Configure other variables and modes in the :config section,
  ;; after lazily loading the package.
  :config

  (evil-add-command-properties #'consult--jump :jump t)
  (evil-add-command-properties #'consult-imenu--jump :jump t)

  ;; Optionally configure preview. The default value
  ;; is 'any, such that any key triggers the preview.
  ;; (setq consult-preview-key 'any)
  ;; (setq consult-preview-key (kbd "M-."))
  ;; (setq consult-preview-key (list (kbd "<S-down>") (kbd "<S-up>")))
  ;; For some commands and buffer sources it is useful to configure the
  ;; :preview-key on a per-command basis using the `consult-customize' macro.

  (setq consult-preview-key
		"M-."
		;; nil
		;; '(:debounce 0.5 any)
		;; 'any
		)
  (consult-customize consult-ripgrep
					 consult-git-grep
					 consult-grep
					 consult-xref
					 consult-line
					 consult--source-bookmark
					 consult--source-recent-file
					 consult--source-project-recent-file
					 :preview-key 'any
					 :sort nil
					 :initial (exec/thing-at-point)
					 )
  (setq consult-async-min-input 1)
  (setq consult-async-refresh-delay 0.2)
  (setq consult-buffer-sources '(
								 consult--source-hidden-buffer
								 consult--source-modified-buffer
								 consult--source-buffer
								 consult--source-file-register
								 consult--source-project-buffer
								 ))

  (setq consult-find-args
		"find . -not ( -wholename */.* -prune )"
		)

  ;; Optionally configure the narrowing key.
  ;; Both < and C-+ work reasonably well.
  (setq consult-narrow-key "<") ;; (kbd "C-+")

  ;; Optionally make narrowing help available in the minibuffer.
  ;; You may want to use `embark-prefix-help-command' or which-key instead.
  ;; (define-key consult-narrow-map (vconcat consult-narrow-key "?") #'consult-narrow-help)

  ;; By default `consult-project-function' uses `project-root' from project.el.
  ;; Optionally configure a different project root function.
  ;; There are multiple reasonable alternatives to chose from.
  ;;;; 1. project.el (the default)
  ;; (setq consult-project-function #'consult--default-project--function)
  ;;;; 2. projectile.el (projectile-project-root)
  ;; (autoload 'projectile-project-root "projectile")
  ;; (setq consult-project-function (lambda (_) (projectile-project-root)))
  ;;;; 3. vc.el (vc-root-dir)
  ;; (setq consult-project-function (lambda (_) (vc-root-dir)))
  ;;;; 4. locate-dominating-file
  ;; (setq consult-project-function (lambda (_) (locate-dominating-file "." ".git")))
  (setq consult-ripgrep-args
		"rg --null --line-buffered --color=never --max-columns=1000 --path-separator /   --smart-case --no-heading --with-filename --line-number --search-zip"
		;; "rg --null --line-buffered --color=never --max-columns=100 --path-separator / --smart-case --no-heading --line-number . "
		)

  (use-package consult-org-roam
	:after org-roam
	:hook (org-roam-mode . consult-org-roam-mode)
	:config
	(setq
	 consult-org-roam-grep-func 'consult-ripgrep
	 )
	)
  (use-package consult-ag)
  (use-package consult-projectile)
  (use-package consult-dir)
  (use-package consult-flycheck
	:config
	)
  (use-package consult-gh)

  (consult-preview-at-point-mode)
  )


(use-package lsp-mode
  :after evil
  :init
  (setq-default lsp-keymap-prefix "C-c l"
				lsp-completion-provider :none
				lsp-diagnostics-provider :flycheck
				lsp-modeline-diagnostics-scope :file
				lsp-use-plists t
				lsp-rust-unstable-features t
				lsp-rust-analyzer-diagnostics-enable-experimental t
				lsp-rust-analyzer-display-chaining-hints t
				lsp-rust-analyzer-display-closure-return-type-hints t
				lsp-rust-analyzer-display-lifetime-elision-hints-enable nil
				lsp-rust-analyzer-display-parameter-hints t
				lsp-rust-analyzer-rustfmt-rangeformatting-enable t
				lsp-rust-analyzer-lens-enable t
				lsp-rust-analyzer-lens-references-adt-enable t
				lsp-rust-analyzer-lens-implementations-enable t
				lsp-rust-analyzer-lens-references-adt-enable t
				lsp-rust-analyzer-lens-references-enum-variant-enable t
				lsp-rust-analyzer-lens-references-method-enable t
				lsp-rust-analyzer-lens-references-trait-enable t
				lsp-rust-analyzer-lens-run-enable t
				lsp-rust-analyzer-lens-debug-enable t
				lsp-rust-analyzer-binding-mode-hints t
				lsp-use-workspace-root-for-server-default-directory t
				lsp-modeline-code-actions-segments '(count icon name)
				lsp-signature-auto-activate
				'(:on-trigger-char :on-server-request :after-completion)
				lsp-xref-force-references t
				)

  (defun exec/rust-ts-mode-lsp-hook()
	(lsp-deferred)
	(flycheck-add-next-checker 'rust-cargo 'rust-clippy)
	(add-hook 'before-save-hook (lambda () (when (eq 'rust-ts-mode major-mode)
											 (lsp-format-buffer))))
	)

  (defun lsp-goto-symbol-occurence (direction)
	"DIRECTION is forward, backward, last, first."
	(unless (lsp--capability "documentHighlightProvider")
	  (signal 'lsp-capability-not-supported (list "documentHighlightProvider")))
	(lsp--goto-symbol-occurent (point) direction))

  (defun lsp--goto-symbol-occurent (a-point direction)
	(lsp-request-async "textDocument/documentHighlight"
					   (lsp--text-document-position-params)
					   (lsp--make-goto-symbol-occurence-callback a-point direction)))

  (defun lsp--make-goto-symbol-occurence-callback (a-point direction)
	(lambda (highlights)
	  (if (> (length highlights) 1)
		  ;; map highlights to a point list
		  (let* ((my--points (-map (lambda (it)
									 (lsp--position-to-point
									  (plist-get (plist-get it :range) :start)
									  )
									 )
								   highlights)
							 )
				 (points (-sort '< my--points))
				 (len (length my--points))
				 (goto--index (pcase direction
								('backward (-find-last-index (lambda (it) (< it a-point)) points))
								('forward  (-find-index (lambda (it) (> it a-point)) points))
								('first 0)
								('last (- len 1))))
				 (goto-index (if goto--index
								 goto--index
							   (if (equal direction 'backward) (- len 1) 0)))
				 (goto-point (nth goto-index points)))
			;; (message "occurence %S/%S"  (+ goto-index 1) len)
			(goto-char goto-point))
		;; (message "only one occurence")
		)
	  )
	)

  (defun lsp-goto-symbol-occurence-forward ()
	(interactive)
	(lsp-goto-symbol-occurence 'forward))

  (defun lsp-goto-symbol-occurence-last ()
	(interactive)
	(lsp-goto-symbol-occurence 'last))

  (defun lsp-goto-symbol-occurence-first ()
	(interactive)
	(lsp-goto-symbol-occurence 'first))

  (defun lsp-goto-symbol-occurence-backward ()
	(interactive)
	(lsp-goto-symbol-occurence 'backward))

  (defun lsp-find-definition-or-reference()
	(interactive)
	(let ((previous-point (point)))
	  (lsp-find-definition)
	  (if (= previous-point (point))
		  (lsp-find-references))))


  :bind
  ("M-i" . lsp-goto-symbol-occurence-backward)
  ("M-o" . lsp-goto-symbol-occurence-forward)
  ("M-RET" . lsp-execute-code-action)
  :hook
  ((shell-mode clojure-mode) . lsp-deferred)
  (rust-ts-mode . exec/rust-ts-mode-lsp-hook)
  (lsp-completionmode . (lambda()
						  (setq completion-category-defaults nil)))
  (lsp-mode . (lambda()
				(let ((lsp-keymap-prefix "C-c l"))
				  (lsp-enable-which-key-integration))))
  :custom-face
  (lsp-inlay-hint-face ((t (:height 0.8))))
  :config

  (define-key lsp-mode-map (kbd "C-c l") lsp-command-map)

  (evil-add-command-properties #'lsp-find-type-definition :jump t)
  (evil-add-command-properties #'lsp-find-definition :jump t)
  (evil-add-command-properties #'goto-line :jump t)
  (evil-add-command-properties #'evil-ex-search-word-forward :jump t)
  (evil-add-command-properties #'org-roam-node-find :jump t)
  (evil-add-command-properties #'lsp-find-definition-or-reference :jump t)

  (setq lsp-completion-no-cache nil
		lsp-completion-sort-initial-results nil
		lsp-eldoc-enable-hover nil
		lsp-eldoc-render-all nil
		lsp-enable-indentation t
		lsp-enable-on-type-formatting t
		lsp-enable-snippet t
		lsp-enable-symbol-highlighting t
		lsp-enable-text-document-color t
		lsp-enable-links nil
		lsp-headerline-breadcrumb-enable-diagnostics nil
		lsp-headerline-arrow "/"
		lsp-idle-delay 0.2
		lsp-inlay-hint-enable t
		lsp-lens-enable t
		lsp-log-io nil
		lsp-references-exclude-definition nil
		lsp-references-exclude-definition t
		lsp-response-timeout 10
		lsp-ui-imenu-auto-refresh t

		lsp-ui-imenu-enable nil
		lsp-headerline-breadcrumb-enable nil
		lsp-semantic-tokens-enable t
		)

  ;; lsp-bash
  (setq lsp-bash-explainshell-endpoint "https://explainshell.com"
		lsp-bash-highlight-parsing-errors t)


  (setq lsp-pylsp-plugins-yapf-enabled t
		lsp-pylsp-plugins-flake8-enabled t
		lsp-pylsp-plugins-pylint-enabled t)

  (setq lsp-semgrep-languages nil)

  ;; (setq assignVariableTypes "assignVariableTypes")
  (lsp-register-custom-settings '(("gopls.allExperiments" t t)
								  ("gopls.completeUnimported" t t)
								  ("gopls.staticcheck" t t)
								  ("gopls.usePlaceholders" t t)
								  ("gopls.allExperiments" t t)
								  ("gopls.hints" ((assignVariableTypes . t)
												  (compositeLiteralFields . t)
												  (compositeLiteralTypes . t)
												  (functionTypeParameters . t)
												  (parameterNames . t)
												  (rangeVariableTypes . t)))))

  (setq lsp-zig-zls-executable "zls")

  (use-package lsp-ui

	:hook
	(lsp . lsp-ui-mode)
	:custom-face
	(lsp-ui-sideline-global ((t (:height 0.6 :underline (:color foreground-color :style wave :position nil)))))
	(lsp-ui-sideline-symbol ((t (:height 0.6))))
	(lsp-ui-sideline-symbol-info ((t (:height 0.6))))
	(lsp-ui-sideline-current-symbol ((t (:height 0.6))))
	(lsp-ui-sideline-code-action ((t (:height 0.6))))
	:config
	;; (defun exec/overwrite-lsp-ui()
	;;   (interactive)

	;;   (defun lsp-headerline--build-path-up-to-project-string ()
	;; 	"Build the path-up-to-project segment for the breadcrumb."
	;; 	(if-let ((root (lsp-headerline--workspace-root)))
	;; 		(let ((segments (or
	;; 						 lsp-headerline--path-up-to-project-segments
	;; 						 (setq lsp-headerline--path-up-to-project-segments
	;; 							   (lsp-headerline--path-up-to-project-root
	;; 								root
	;; 								(lsp-f-parent (buffer-file-name)))))))
	;; 		  (mapconcat (lambda (next-dir)
	;; 					   (propertize next-dir
	;; 								   'font-lock-face
	;; 								   (lsp-headerline--face-for-path
	;; 									(get-text-property
	;; 									 0 'lsp-full-path next-dir))))
	;; 					 segments
	;; 					 (concat (lsp-headerline--arrow-icon) "")))
	;; 	  ""))

	;;   (defun lsp-headerline--build-file-string ()
	;; 	"Build the file-segment string for the breadcrumb."
	;; 	(let* ((file-path (or (buffer-file-name) ""))
	;; 		   (filename (f-filename file-path)))
	;; 	  (if-let ((file-ext (f-ext file-path)))
	;; 		  (concat (lsp-icons-get-by-file-ext file-ext 'headerline-breadcrumb)
	;; 				  ""
	;; 				  (propertize filename
	;; 							  'font-lock-face
	;; 							  (lsp-headerline--face-for-path file-path)))
	;; 		filename)))


	;;   (defun lsp-headerline--build-string ()
	;; 	"Build the header-line string."
	;; 	(string-trim-right
	;; 	 (mapconcat
	;; 	  (lambda (segment)
	;; 		(let ((segment-string
	;; 			   (pcase segment
	;; 				 ('project (lsp-headerline--build-project-string))
	;; 				 ('file (lsp-headerline--build-file-string))
	;; 				 ('path-up-to-project (lsp-headerline--build-path-up-to-project-string))
	;; 				 ('symbols (lsp-headerline--build-symbol-string))
	;; 				 (_ (lsp-log "'%s' is not a valid entry for `lsp-headerline-breadcrumb-segments'"
	;; 							 (symbol-name segment))
	;; 					""))))
	;; 		  (if (eq segment-string "")
	;; 			  ""
	;; 			(concat (lsp-headerline--arrow-icon)
	;; 					""
	;; 					segment-string
	;; 					""))))
	;; 	  lsp-headerline-breadcrumb-segments
	;; 	  "")))

	;;   (defun lsp-headerline--build-symbol-string ()
	;; 	"Build the symbol segment for the breadcrumb."
	;; 	(if (lsp-feature? "textDocument/documentSymbol")
	;; 		(-if-let* ((lsp--document-symbols-request-async t)
	;; 				   (symbols (lsp--get-document-symbols))
	;; 				   (symbols-hierarchy (lsp--symbols->document-symbols-hierarchy symbols))
	;; 				   (enumerated-symbols-hierarchy
	;; 					(-map-indexed (lambda (index elt)
	;; 									(cons elt (1+ index)))
	;; 								  symbols-hierarchy)))
	;; 			(mapconcat
	;; 			 (-lambda (((symbol &as &DocumentSymbol :name)
	;; 						. index))
	;; 			   (let* ((symbol2-name
    ;; 					   (propertize name
	;; 								   'font-lock-face
	;; 								   (lsp-headerline--face-for-symbol symbol)))
	;; 					  (symbol2-icon (lsp-headerline--symbol-icon symbol))
	;; 					  (full-symbol-2
	;; 					   (concat
	;; 						(if lsp-headerline-breadcrumb-enable-symbol-numbers
	;; 							(concat
	;; 							 (propertize (number-to-string index)
	;; 										 'face
	;; 										 'lsp-headerline-breadcrumb-symbols-face)
	;; 							 "")
	;; 						  "")
	;; 						(if symbol2-icon
	;; 							(concat symbol2-icon symbol2-name)
	;; 						  symbol2-name))))
	;; 				 (lsp-headerline--symbol-with-action symbol full-symbol-2)))
	;; 			 enumerated-symbols-hierarchy
	;; 			 (concat "⭢"
	;; 					 ;; (lsp-headerline--arrow-icon)
	;; 					 ))
	;; 		  "")
	;; 	  ""))

	;;   )
	;; (add-hook 'lsp-ui-mode-hook 'exec/overwrite-lsp-ui)



	(setq-default lsp-imenu-sort-methods nil
				  lsp-ui-doc-show-with-cursor nil
				  lsp-ui-doc-delay 1.0
				  lsp-ui-doc-header t
				  lsp-ui-doc-use-childframe t
				  lsp-ui-doc-use-webkit nil
				  lsp-ui-doc-include-signature t
				  lsp-ui-doc-position 'top
				  lsp-ui-sideline-enable nil)

	;; (general-evil-define-key 'normal 'lsp-mode-map
	;;   "M-b" 'lsp-find-definition-or-reference
	;;   )
	;; (add-hook 'prog-mode-hook 'evil-normalize-keymaps)
	(evil-define-minor-mode-key 'normal 'lsp-mode
	  (kbd "M-b") 'lsp-find-definition-or-reference)

	(general-nmap :keymaps 'lsp-mode-map
	  "gD" 'lsp-find-declaration
	  "gt" 'lsp-find-type-definition
	  "gd" 'lsp-find-definition
	  "gr" 'lsp-find-references
	  "gu" 'lsp-rust-find-parent-module
	  )

	(general-nmap :keymaps 'lsp-ui-mode-map
	  "gi" 'lsp-ui-peek-find-implementation
	  "gs" 'lsp-ui-find-workspace-symbol
	  "M-d" 'lsp-ui-doc-glance
	  )
	(general-def :keymaps 'lsp-ui-peek-mode-map
	  "j" 'lsp-ui-peek--select-next
	  "k" 'lsp-ui-peek--select-prev
	  "C-j" 'lsp-ui-peek--select-next
	  "C-k" 'lsp-ui-peek--select-prev)


	)

  (use-package lsp-grammarly)

  (use-package consult-lsp
	:disabled
	:after consult)

  (use-package lsp-pyright
	:hook
	(python-mode . lsp-deferred)
	:config
	(setq lsp-pyls-server-command "pyright")
	(setq lsp-pyright-use-library-code-for-types t) ;; set this to nil if getting too many false positive type errors
	(setq lsp-pyright-stub-path "~/Projects/github.com/microsoft/python-type-stubs")))


(use-package yasnippet
  :hook (after-init . yas-global-mode)
  :config
  (setq yas-indent-line 'fixed)
  (yas-reload-all)
  (use-package yasnippet-snippets
	:after yasnippet)
  )

(use-package breadcrumb
  :hook
  (after-init . breadcrumb-mode)
  :config
  (defun exec/breadcrumb-imenu-crumbs (s_point)
	(when-let ((alist (bc--ipath-alist)))
      (when (cl-some #'identity alist)
		(bc--summarize
		 (cl-loop
          for (p . more) on (bc-ipath alist s_point)
          collect (bc--format-ipath-node p more))
		 (bc--length bc-imenu-max-length)
		 (propertize bc-imenu-crumb-separator
					 'face 'bc-face)))))


  )

;; (use-package lsp-bridge
;;   :straight (lsp-bridge :type git :host github :repo "manateelazycat/lsp-bridge" :files ("*"))
;;   :config
;;   (setq-default lsp-bridge-enable-hover-diagnostic t
;; 				lsp-bridge-enable-completion-in-string t
;; 				lsp-bridge-enable-completion-in-minibuffer t
;; 				acm-menu-length 30
;; 				acm-enable-copilot t
;; 				lsp-bridge-user-langserver-dir "~/.emacs.d/lsp-bridge/user-langserver-dir"
;; 				acm-completion-backend-merge-order '(
;; 													 "template-first-part-candidates"
;; 													 "template-second-part-candidates"
;; 													 "copilot-candidates"
;; 													 "mode-first-part-candidates"
;; 													 "mode-second-part-candidates"
;; 													 "tabnine-candidates"
;; 													 "codeium-candidates"
;; 													 )
;; 				)

;;   (add-hook 'acm-mode-hook 'evil-normalize-keymaps)
;;   (general-imap :keymaps 'acm-mode-map
;; 	"C-j" 'acm-select-next
;; 	"C-k" 'acm-select-prev
;; 	"C-h" 'acm-select-first
;; 	"C-l" 'acm-select-last
;; 	"C-f" 'acm-select-next-page
;; 	"C-b" 'acm-select-prev-page
;; 	"C-S-j" 'acm-doc-scroll-down
;; 	"C-S-k" 'acm-doc-scroll-up
;; 	)


;;   (general-nmap :keymaps 'lsp-bridge-ref-mode-map
;; 	"q" 'lsp-bridge-ref-quit
;; 	"C-j" 'next-line
;; 	"C-k" 'previous-line
;; 	"RET" 'lsp-bridge-ref-open-file-and-stay
;; 	"SPC" 'lsp-bridge-ref-open-file
;; 	"j" 'lsp-bridge-ref-jump-next-keyword
;; 	"k" 'lsp-bridge-ref-jump-prev-keyword
;; 	"l" 'lsp-bridge-ref-jump-next-file
;; 	"h" 'lsp-bridge-ref-jump-prev-file
;; 	)

;;   (general-nmap :keymaps 'lsp-bridge-mode-map
;; 	"gd" 'lsp-bridge-find-def
;; 	"gt" 'lsp-bridge-find-type-def
;; 	"gr" 'lsp-bridge-find-references
;; 	"gR" 'lsp-bridge-find-def-return
;; 	"gi" 'lsp-bridge-find-impl)

;;   (add-hook 'lsp-bridge-peek-mode-hook 'evil-normalize-keymaps)

;;   (general-nmap :keymaps 'lsp-bridge-peek-keymap
;; 	"j"  'lsp-bridge-peek-file-content-next-line
;; 	"k"  'lsp-bridge-peek-file-content-prev-line
;; 	"J"  'lsp-bridge-peek-list-next-line
;; 	"K"  'lsp-bridge-peek-list-prev-line
;; 	)

;;   (general-imap :keymaps 'lsp-bridge-mode-map
;; 	"C-SPC" 'lsp-bridge-popup-complete-menu
;; 	)


;;   (global-lsp-bridge-mode))


(use-package keycast
  :hook (after-init . keycast-tab-bar-mode)
  )

(use-package command-log-mode
  :custom
  (command-log-mode-key-binding-open-log "H-p l")
  :straight (command-log-mode :type git :repo "lewang/command-log-mode")
  :config
  (setq command-log-mode-is-global t
		command-log-mode-key-binding-open-log nil
		command-log-mode-window-size 80
		)
  (global-command-log-mode)
  )

(use-package powerthesaurus)


(use-package mode-line-bell)

(defun exec/double-flash-mode-line ()
  (let ((flash-sec (/ 1.0 10)))
	(invert-face 'mode-line)
	(run-with-timer flash-sec nil #'invert-face 'mode-line)
	;; (run-with-timer (* 2 flash-sec) nil #'invert-face 'mode-line)
	;; (run-with-timer (* 3 flash-sec) nil #'invert-face 'mode-line)
	))


(use-package rainbow-mode
  :hook
  (
   (prog-mode . rainbow-mode)
   (text-mode . rainbow-mode)
   (conf-mode . rainbow-mode)
   )
  )

(use-package rainbow-delimiters
  :hook ((prog-mode emacs-lisp-mode minibuffer-mode) .  rainbow-delimiters-mode)
  :config
  )

(use-package color-identifiers-mode
  :config
  (global-color-identifiers-mode)
  )

(use-package indent-bars
  :straight (indent-bars :type git :host github :repo "jdtsmith/indent-bars")
  :hook (prog-mode  . indent-bars-mode)
  :custom
  (indent-bars-treesit-support t)
  (indent-bars-no-descend-string t)
  (indent-bars-treesit-ignore-blank-lines-types '("module"))
  (indent-bars-prefer-character t)
  (indent-bars-treesit-wrap '((python argument_list parameters ; for python, as an example
									  list list_comprehension
									  dictionary dictionary_comprehension
									  parenthesized_expression subscript)))

  )

(use-package exercism
  ;; :straight (exercism.el :type git :host github
  ;; 				   :repo "anonimitoraf/exercism.el"
  ;; 				   )
  :config
  (setq exercism-directory "~/Projects/github.com/eval-exec/exercism")
  )


(use-package persistent-scratch
  :config
  (add-hook 'after-init-hook 'persistent-scratch-setup-default)
  )


(use-package beacon
  :disabled t
  :hook (after-init . beacon-mode)
  :config
  (setq beacon-blink-when-focused t
		beacon-blink-when-buffer-changes t
		beacon-blink-when-window-scrolls t
		beacon-blink-when-window-changes t
		beacon-blink-when-point-moves-vertically t
		beacon-blink-when-point-moves-horizontally t
		beacon-color "purple")
  )

(use-package all-the-icons
  :config
  (setq all-the-icons-scale-factor 0.8
		all-the-icons--cache-limit 8192
		)
  )


(use-package ibuffer
  :bind ("C-x C-b" . ibuffer)
  :config

  (setq ibuffer-formats '(
						  (mark modified read-only locked " " (name 36 36 :left :elide) " " (size 9 -1 :right) " " (mode 16 16 :left :elide) " " filename-and-process)
						  (mark " " (name 16 -1) " " filename)))


  )
(use-package ibuffer-sidebar
  ;; :hook (after-init . ibuffer-sidebar-show-sidebar)
  :config
  (setq ibuffer-sidebar-use-custom-font t
		ibuffer-sidebar-face '(:family "Iosevka" :height 0.8)
		ibuffer-sidebar-name "ibuffer-sidebar"
		ibuffer-sidebar-display-alist '((side . left)
										(slot . 2)
										(window-height . 0.3)
										)
		ibuffer-sidebar-refresh-timer 1
		)

  (custom-set-faces '(ibuffer-sidebar-face ((t (:family "Iosevka" :height 0.8)))))
  )

(use-package all-the-icons-ibuffer
  :init (setq  all-the-icons-ibuffer-human-readable-size t)
  (setq all-the-icons-ibuffer-formats '((mark modified read-only locked
											  " " (icon 2 2 :left :elide)
											  " " (name 80 -1 :left :elide)
											  " " (size-h 10 -1 :left)
											  " " (mode+ 24 -1 :left)
											  " " (filename-and-process+ -1 -1 :left))))
  :config (all-the-icons-ibuffer-mode 1))

(add-hook 'image-mode-hook '(lambda()
							  (blink-cursor-mode -1)
							  ))

(use-package pdf-tools
  :mode ("\\.pdf\\'" . pdf-view-mode)
  :hook (pdf-view . (lambda()
					  ;; disable cursor blink
					  (blink-cursor-mode -1)
					  ))
  :custom
  (pdf-view-display-size  'fit-height)
  ;; :hook (pdf-view-mode . pdf-view-auto-slice-minor-mode)
  :config
  (setq pdf-view-use-scaling t)
  (setq pdf-view-use-imagemagick nil)
  (setq pdf-cache-image-limit 1024)
  (setq pdf-cache-prefetch-delay 0.3)
  (setq pdf-view-bounding-box-margin 0.01)

  (general-nmap :keymaps 'pdf-view-mode-map
	"j" 'pdf-view-scroll-up-or-next-page
	"k" 'pdf-view-scroll-down-or-previous-page
	)

  (use-package toc-mode)

  (use-package pdfgrep
	:hook
	(pdf-view-mode . pdfgrep-mode)
	)

  (use-package saveplace-pdf-view
	:hook
	(pdf-view-mode . save-place-mode)
	)
  )

(use-package image-roll
  :straight (:host github :repo "dalanicolai/image-roll.el")
  )

;; (use-package pdf-continuous-scroll-mode
;; :load-path "/home/exec/.emacs.d/elisp/pdf-continuous-scroll-mode.el"
;; :hook (pdf-view-mode-hook . pdf-continuous-scroll-mode)
;; )

(use-package prompts
  )


(use-package cargo
  :hook
  (cargo-process-mode . ansi-color-for-comint-mode-on)
  (cargo-mode . ansi-color-for-comint-mode-on)
  )
(setq compilation-scroll-output t)
;; (add-hook 'compilation-mode-hook 'ansi-color-for-comint-mode-on)
;; (add-to-list 'comint-output-filter-functions 'ansi-color-process-output)

(use-package cargo-transient
  :custom
  (cargo-transient-buffer-name-function
   project-prefixed-buffer-name))

(use-package ibuffer-projectile
  ;;:functions all-the-icons-octicon ibuffer-do-sort-by-alphabetic
  :hook
  ((ibuffer-mode . (lambda ()
					 (message "ibuffer projectile groups")
					 (ibuffer-projectile-set-filter-groups)
					 (unless (eq ibuffer-sorting-mode 'alphabetic)
					   (ibuffer-do-sort-by-alphabetic)))))
  :config
  (setq ibuffer-projectile-prefix
		(concat
		 (all-the-icons-octicon "file-directory"
								:face
								ibuffer-filter-group-name-face
								:v-adjust 0.0
								:height 1.0) " ")))




;; (with-eval-after-load 'counsel
;;   (with-no-warnings
;;     (defun my-ibuffer-find-file ()
;;       (interactive)
;;       (let ((default-directory (let ((buf (ibuffer-current-buffer)))
;;                                  (if (buffer-live-p buf)
;;                                      (with-current-buffer buf
;;                                        default-directory)
;;                                    default-directory))))
;;         (counsel-find-file default-directory)))
;;     (advice-add #'ibuffer-find-file :override #'my-ibuffer-find-file))))

;; Group ibuffer's list by project root
(use-package leetcode
  :custom
  (leetcode-prefer-language  "cpp")
  (leetcode-prefer-sql   "mysql")
										;(leetcode-save-solutions . t)
										;(leetcode-directory . "/home/exec/github.com/eval-exec/Algorithm/LeetCode/eleet")
  )
;; (set inferior-lisp-program "sbcl")
;; (use-package common-lisp-snippets)


(use-package dash
  :hook
  (after-init . global-dash-fontify-mode)
  :config
  (setq dash-fontify-mode-lighter " Dash")
  )

(use-package rust-playground
  :config
  (setq rust-playground-cargo-toml-template
		"[package]\nname = \"rust-playground\"\nversion = \"0.1.0\"\nauthors = [\"Eval EXEC<execvy@gmail.com>\"]\nedition = \"2021\"\n\n[dependencies]"
		rust-playground-confirm-deletion nil
		rust-playground-basedir "/tmp/rust-playground"
		)
  )
(use-package cargo-mode)
(use-package js2-mode)

(use-package emr
  )

(use-package rust-mode
  :config
  )
(use-package treesit-auto
  :demand t
  :config
  (setq treesit-auto-install t
		treesit-auto-langs '(
							 bash
							 bibtex
							 c
							 c-sharp
							 clojure
							 cmake
							 commonlisp
							 cpp
							 css
							 dart
							 dockerfile
							 elixir
							 go
							 gomod
							 heex
							 html
							 java
							 javascript
							 json
							 julia
							 kotlin
							 latex
							 lua
							 make
							 markdown
							 proto
							 python
							 r
							 ruby
							 rust
							 toml
							 tsx
							 typescript
							 typst
							 verilog
							 vhdl
							 yaml
							 awk
							 )
		)
  (treesit-auto-add-to-auto-mode-alist)

  (global-treesit-auto-mode 1)
  )

(add-to-list 'auto-mode-alist '("/\\(Cargo.lock\\|\\.cargo/config\\)\\'" . toml-ts-mode))

(add-to-list 'auto-mode-alist '("//.md//'" . markdown-mode))

;; (use-package tree-sitter-langs)
;; (add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode)

;; (add-to-list 'auto-mode-alist '("\\.go\\'" . go-ts-mode))
;; (add-to-list 'auto-mode-alist '("\\.rs\\'" . rust-ts-mode))
;; (add-to-list 'major-mode-remap-alist '(c-mode . c-ts-mode))
;; (add-to-list 'major-mode-remap-alist '(c++-mode . c++-ts-mode))
;; (add-to-list 'major-mode-remap-alist '(python-mode . python-ts-mode))
;; (add-to-list 'major-mode-remap-alist '(sh-mode . bash-ts-mode))
;; (add-to-list 'major-mode-remap-alist '(makefile-mode . cmake-ts-mode))
;; (add-to-list 'major-mode-remap-alist '(conf-toml-mode . toml-ts-mode))



(use-package git-commit)

(use-package git-timemachine)

(use-package solidity-mode)

(use-package calendar
  :config (setq calendar-latitude 39.903829718
				calendar-longitude 116.374498502)
  (setq view-diary-entries-initially t
		mark-diary-entries-in-calendar t
		number-of-diary-entries 7)
  (setq diary-file "~/org/diary/diary"))


(use-package helpful
  ;; :bind
  ;; Note that the built-in `describe-function' includes both functions
  ;; and macros. `helpful-function' is functions only, so we provide
  ;; `helpful-callable' as a drop-in replacement.
  ;; (
  ;; ("H-h f" . helpful-callable)
  ;; ("H-h v" . helpful-variable)
  ;; ("H-h k" . helpful-key)
  ;; ("H-h F" . helpful-function)
  ;; ("H-c P" . helpful-at-point)

  ;; Look up *C*ommands.
  ;;
  ;; By default, C-h C is bound to describe `describe-coding-system'. I
  ;; don't find this very useful, but it's frequently useful to only
  ;; look at interactive functions.
  ;; ("H-h C" . helpful-command))
  :custom-face
  (helpful-heading ((t (:foreground "cyan" :height 1.2))))
  :config
  (setq help-window-select t)
  )

(use-package 2048-game)

(use-package super-save
  :init
  (setq auto-save-default nil)
  :config
  (setq super-save-auto-save-when-idle nil
		super-save-idle-duration 10
		super-save-hook-triggers '(evil-insert-state-exit-hook
								   evil-operator-state-exit-hook
								   evil-replace-state-exit-hook
								   mouse-leave-buffer-hook focus-out-hook)
		)

  ;; (addt- 's- 'evil-insert---)
  ;; (add-to-list 'super--triggers 'evil-replace-state-exit-hook)
  ;; (add-to-list 'super---triggers 'evil-operator-state-exit-hook)
  (super-save-mode +1)
  )


(use-package hungry-delete
  :config
  (global-hungry-delete-mode)
  )


(defun exec/nov-mode-face()
  (interactive)
  ;; (setq-local buffer-face-mode-face '(
  ;; 									  :family "Sarasa Gothic SC"
  ;; 									  :height 2.0
  ;; 									  :background "white"
  ;; 									  :foreground "black"
  ;; 									  ))
  ;; (make-local-variable 'buffer-face-mode-face)
  ;; (blink-cursor-mode -1)
  ;; (tab-bar-mode -1)
  ;; (buffer-face-mode)
  )

(use-package nov
  :hook
  (nov-mode . exec/nov-mode-face)
  ;; (nov-mode . writeroom-mode)
  :config
  (setq nov-unzip-program "unzip"
		nov-text-width t
		visual-fill-column-center-text nil
		nov-variable-pitch nil
		)
  (add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode))

  ;; create a timer: every 1 second, call (next-line), if (next-line) report error, call (nov-next-document)

  (defun exec/nov-next-line()
	(interactive)
	(when (eq major-mode 'nov-mode)
	  (condition-case err
		  (progn
			(pixel-scroll-up))
		(error
		 (nov-next-document)))))
  )
;; (use-package nov-xwidget
;;   :demand t
;;   :after nov
;;   :config
;;   (define-key nov-mode-map (kbd "o") 'nov-xwidget-view)
;;   (add-hook 'nov-mode-hook 'nov-xwidget-inject-all-files))

(use-package olivetti
  :config
  (setq olivetti-body-width 0.8)
  )

(use-package scrollkeeper
  :disabled
  :config
  )
(use-package better-scroll
  :disabled
  :after evil
  :config
  (better-scroll-setup)

  (define-key global-map (kbd "<prior>") #'better-scroll-down)
  (define-key global-map (kbd "<next>") #'better-scroll-up)
  (define-key global-map (kbd "S-<prior>") #'better-scroll-down-other-window)
  (define-key global-map (kbd "S-<next>") #'better-scroll-up-other-window)


  (general-evil-define-key 'motion 'global
	"C-f" 'better-scroll-up
	"C-b" 'better-scroll-down)
  )

(use-package winner
  ;; :bind(
  ;; 		("H-<left>" . winner-undo)
  ;; 		("H-<right>" . winner-redo)
  ;; 		)
  :config
  (winner-mode))

(use-package ace-window
  :bind ("H-o" . ace-window)
  :custom-face
  (aw-leading-char-face ((t (
							 :foreground "red"
							 :background "yellow"
							 :height 10.0 :box '(
												 :line-width -1
												 :color "red"
												 :style nil) ))))
  :config
  (setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l)
		aw-dispatch-when-more-than 0
		aw-background nil
		)

  (ace-window-posframe-mode)
  )

(use-package pangu-spacing
  :custom
  (pangu-spacing-real-insert-separtor  t)
  (pangu-spacing-inhibit-mode-alist  '(eshell-mode shell-mode term-mode vterm-mode))
  :hook
  ((prog-mode emacs-lisp-mode org-mode org-journal-mode) . pangu-spacing-mode)
  )
;; (use-package websocket
;;   :straight (websocket :host github :repo "ahyatt/emacs-websocket" :branch main)
;;   )

;; (use-package deno-bridge
;;   :straight (deno-bridge :host github :repo "manateelazycat/deno-bridge")
;;   :config
;;   )


;; (use-package deno-bridge-jieba
;;   :disabled
;;   :straight (deno-bridge-jieba :host github :repo "ginqi7/deno-bridge-jieba")
;;   :config
;;   ;; 早上好，你好吗我能吞下玻璃而不伤身体
;;   (deno-bridge-jieba-start)
;;   (general-def :states '(normal motion visual) :keymaps 'global
;; 	"e" 'deno-bridge-jieba-forward-word
;; 	"b" 'deno-bridge-jieba-backward-word
;; 	)

;;   )

(use-package eglot
  :disabled
  :config
  (setq eglot-autoshutdown t)
  (setq eglot-extend-to-xref t)
  )

(setq confirm-kill-emacs 'yes-or-no-p)


(use-package recentf
  :custom ((recentf-auto-cleanup  'never)
		   (recentf-exclude  nil)
		   (recentf-max-menu-items  1000)
		   (recentf-max-saved-items  1000))
  :config
  (recentf-mode)
  )

(use-package saveplace
  :config
  (save-place-mode))

(use-package restore-point
  :ensure nil
  :straight (restore-point :type git :host github :repo "arthurcgusmao/restore-point")
  :hook (after-init . restore-point-mode))

(use-package atomic-chrome
  :hook
  (after-init . atomic-chrome-start-server)
  :config
  (setq atomic-chrome-enable-auto-update t)
  )





(defun toggle-display-global-line-numbers()
  (interactive)
  (if (bound-and-true-p global-display-line-numbers-mode)
	  (setq on -1)
	(setq on +1))
  (global-display-line-numbers-mode on)
  )

(defun toggle-display-line-numbers()
  (setq display-line-numbers 'visual)
  (setq display-line-numbers-type 'visual)
  (setq on +1)
										;(interactive)
  (if (bound-and-true-p display-line-numbers-mode)
	  (setq on -1))
  (display-line-numbers-mode on)
  )

;; (global-set-key (kbd "<f6>")
;; 				(lambda ()
;; 				  (interactive)
;; 				  (toggle-display-line-numbers)))

;; (global-set-key (kbd "C-c <f6>")
;; 				(lambda ()
;; 				  (interactive)
;; 				  (toggle-display-global-line-numbers)))


(use-package telega
  ;; :straight (:type built-in)
  :config
  (setq telega-animation-play-inline nil)
  (setq telega-chat-show-avatars t)
  (setq telega-photo-show-details nil)
  (setq telega-translate-to-language-by-default "zh-CN")
  (setq telega-server-libs-prefix "/nix/store/dbz1l9mipbn0q22rk3rzr0cxwgns5ihm-tdlib-1.8.19")
  )

;; (use-package plz
;;   :config
;;   (setq plz-connect-timeout 30)
;;   (setq plz-curl-default-args '(
;; 								"--silent" "--compressed" "--location" "--dump-header"
;; 								"-"
;; 								"--proxy"
;; 								"http://127.0.0.1:7890"
;; 								))
;; )

(use-package mu4e
  :init
  (defun exec/clip-to-PNG ()
    (interactive)
    (when (string-match-p (regexp-quote "image/png") (shell-command-to-string "xclip -selection clipboard -o -t TARGETS"))
	  (let
		  ((image-file (concat "/tmp/" (format-time-string "tmp_%Y%m%d_%H%M%S.png"))))
        (shell-command-to-string (concat "xclip -o -selection clipboard -t image/png > " image-file))
        image-file)))

  (defun exec/mu4e-attach-image-from-clipboard ()
    (interactive)
    (let ((image-file (exec/clip-to-PNG)) ;; paste clipboard to temp file
		  (pos (point-marker)))
	  (when image-file
        (goto-char (point-max))
        (mail-add-attachment image-file)
        (goto-char pos))))


  :straight (:type built-in)
  :config

  (general-def 'normal mu4e-main-mode-map
	"q" 'previous-buffer
	)

  (setq mu4e-mu-binary (executable-find "mu"))
  ;; use mu4e for e-mail in emacs
  (setq read-mail-command 'mu4e
		mu4e-eldoc-support t
		)
  (setq mail-user-agent 'mu4e-user-agent)


  ;; don't save message to Sent Messages, Gmail/IMAP takes care of this
  ;; (setq mu4e-sent-messages-behavior 'delete)

  ;; (See the documentation for `mu4e-sent-messages-behavior' if you have
  ;; additional non-Gmail addresses and want assign them different
  ;; behavior.)

  ;; setup some handy shortcuts
  ;; you can quickly switch to your Inbox -- press ``ji''
  ;; then, when you want archive some messages, move them to
  ;; the 'All Mail' folder by pressing ``ma''.

  (setq mu4e-maildir-shortcuts
		'(
		  (:maildir "/execvy/inbox" :key ?a)
		  (:maildir "/execvy/sent" :key ?s)
		  (:maildir "/execvy/spam" :key ?S)
		  (:maildir "/execvy/trash" :key ?t)
		  ))

										; (setq mu4e-maildir-shortcuts
										; '( (:maildir "/INBOX"              :key ?i)
										;    (:maildir "/[Gmail].Sent"  :key ?s)
										;    (:maildir "/[Gmail].Trash"      :key ?t)
										;    ;; (:maildir "/[Gmail].All Mail"   :key ?a)
										;    ))

										; (add-to-list 'mu4e-bookmarks
										; 	   ;; ':favorite t' i.e, use this one for the modeline
										; 	   '(:query "maildir:/inbox" :name "Inbox" :key ?i :favorite t)
										; 	   )

  (setq mu4e-bookmarks '(
						 ("flag:unread"                       "Unread messages"                  ?u)
						 (""                                  "All messages"                     ?a)
						 ("date:today..now"                   "Today's messages"                 ?t)
						 ("date:1d..now"                      "Last 1 days"                      ?y)
						 ("date:7d..now"                      "Last 7 days"                      ?w)
						 ("flag:f"                            "starred"                          ?m)
						 ("maildir:/sent"                     "sent"                             ?s)
						 ("maildir:/drafts"                   "drafts"                           ?d)
						 ("mime:image/*"                      "Messages with images"             ?p)
						 ("maildir:/trash"                    "Trash"                            ?G)
						 ("from:github.com OR from:mail.notion.so" "Github & Notion"             ?i)
						 ))

  ;; allow for updating mail using 'U' in the main view:
  (setq mu4e-get-mail-command "true"
		mu4e-index-update-in-background nil
		mu4e-update-interval nil
		mu4e-index-cleanup t
		mu4e-index-lazy-check nil
		mu4e-notification-support t
		mu4e-speedbar-support nil
		)


  (setq mu4e-use-fancy-chars t
		mu4e-modeline-support t
		mu4e-marker-icons-use-unicode t
		mu4e-debug nil
		mu4e-hide-index-messages t
		mu4e-search-threads t
		mu4e-headers-fields '((:human-date . 21) (:flags . 8) (:mailing-list . 12) (:from . 24)
							  (:subject)))

  (setq mu4e-date-format-long "%c"
		mu4e-headers-date-format "%x %T"
		mu4e-headers-long-date-format "%c %T"
		mu4e-headers-time-format "%T")


  ;; something about ourselves
  (setq
   user-mail-address "execvy@gmail.com"
   user-full-name  "Eval EXEC"
   mu4e-compose-signature
   (concat
    ""
    ""))
  (setq  mu4e-headers-thread-single-orphan-prefix '("─>" . "─▶")
		 mu4e-headers-thread-orphan-prefix        '("┬>" . "┬▶ ")
		 mu4e-headers-thread-connection-prefix    '("│ " . "│ ")
		 mu4e-headers-thread-first-child-prefix   '("├>" . "├▶")
		 mu4e-headers-thread-child-prefix         '("├>" . "├▶")
		 mu4e-headers-thread-last-child-prefix    '("└>" . "╰▶"))


  ;; sending mail -- replace USERNAME with your gmail username
  ;; also, make sure the gnutls command line utils are installed
  ;; package 'gnutls-bin' in Debian/Ubuntu

  (setq send-mail-function 'sendmail-send-it)
  ;; (require 'smtpmail)
  ;; (setq message-send-mail-function 'smtpmail-send-it
  ;;    starttls-use-gnutls t
  ;;    smtpmail-starttls-credentials '(("smtp.gmail.com" 587 nil nil))
  ;;    smtpmail-auth-credentials
  ;;      '(("smtp.gmail.com" 587 "USERNAME@gmail.com" nil))
  ;;    smtpmail-default-smtp-server "smtp.gmail.com"
  ;;    smtpmail-smtp-server "smtp.gmail.com"
  ;;    smtpmail-smtp-service 587)

  ;; alternatively, for emacs-24 you can use:
  ;; (setq message-send-mail-function 'smtpmail-send-it
  ;;     smtpmail-stream-type 'starttls
  ;;     smtpmail-default-smtp-server "smtp.gmail.com"
  ;;     smtpmail-smtp-server "smtp.gmail.com"
  ;;     smtpmail-smtp-service 587
  ;; )

  ;; don't keep message buffers around
  (setq message-kill-buffer-on-exit t)

  )
(use-package mu4e-marker-icons
  :config
  (mu4e-marker-icons-mode)
  )
(use-package mu4e-views
  :disabled
  :config
  ;; (setq mu4e-views-default-view-method "html")
  )

(use-package ement
  :config
  (setq ement-notify-dbus-p nil
		ement-initial-sync-timeout 600
		)
  (defun exec/ement-connect ()
	(interactive)
	(ement-connect
	 :user-id "@evil-neo:matrix.org"
	 :uri-prefix "https://matrix.org"))

  (setq ement-room-message-format-spec
		"[%S%L]: %B%r%R%t"
		ement-room-list-column-Name-max-width 40
		ement-room-left-margin-width 24
		ement-room-retro-messages-number 1000
		)

  (evil-collection-ement-setup)
  (setq evil-collection-ement-want-auto-retro t)
  (general-nmap :keymaps 'ement-room-mode-map
	"C-b" 'ement-room-scroll-down-command
	)
  )


(use-package mermaid-mode
  :config
  (setq mermaid-output-format "png")
  (setq mermaid-flags "-s 3")
  )

(use-package gnuplot)
(use-package mpv)
(use-package netease-cloud-music
  :config
  )

(use-package vimrc-mode)

(use-package format-all
  ;; :hook
  ;; (prog-mode . format-all-mode)
  ;; (emacs-lisp-mode . format-all-mode)
  ;; (nix-mode . format-all-mode)
  :config

  (setq-default format-all-show-errors "Never"
				format-all-debug nil)

  (setq-default format-all-formatters   '(
										  ("Emacs Lisp" emacs-lisp)
										  ("Nix" nixfmt)
										  ("Rust" rustfmt)
										  ("Shell" shfmt)
										  ("C" clang-format)
										  ("C++" clang-format)
										  ))
  ;; remove hook initially assigned when autoload
  ;; (remove-hook 'before-save-hook 'format-all--buffer-from-hook t)

  ;; (defun exec/format-all-buffer ()
  ;; 	"format-all-buffer without jumps of cursor"
  ;; 	(interactive)
  ;; 	(let ((point (point)) (wstart (window-start)))
  ;;     (format-all-buffer)
  ;;     (goto-char point)
  ;;     (set-window-start (selected-window) wstart)))
  ;; (add-hook 'before-save-hook 'exec/format-all-buffer)
  )

(use-package apheleia
  :config
  (apheleia-global-mode -1)
  )


(use-package clang-format)

(defun skx/update-org-modified-property ()
  "If a file contains a '#+LAST_MODIFIED' property update it to contain
		the current date/time"
  (interactive)
  (save-excursion (widen)
				  (goto-char (point-min))
				  (when (re-search-forward "^#\\+LAST_MODIFIED:" (point-max) t)
					(progn (kill-line)
										;(insert (format-time-string " %d/%m/%Y %H:%M:%S") )))))
						   (insert (format-time-string " [%Y-%m-%d %a %H:%M]") ))))
  )



(defun solar-sunrise-string (date &optional nolocation)
  "String of *local* time of sunrise and daylight on Gregorian DATE."
  (let ((l (solar-sunrise-sunset date)))
	(format "%s (%s hours daylight)" (if (car l)
										 (concat "Sunset " (apply 'solar-time-string (car l)))
									   "no sunset")
			(nth 2 l)))
  )
;; To be called from diary-list-sexp-entries, where DATE is bound.
;;;###diary-autoload
(defun diary-sunrise ()
  "Local time of sunrise as a diary entry.
		Accurate to a few seconds."
  (or (and calendar-latitude
		   calendar-longitude
		   calendar-time-zone
		   )
	  (solar-setup)
	  )
  (solar-sunrise-string date)
  )

(defun solar-sunset-string (date &optional nolocation)
  "String of *local* time of sunset and daylight on Gregorian DATE."
  (let ((l (solar-sunrise-sunset date)))
	(format "%s (%s hours daylight)" (if (cadr l)
										 (concat "Sunset " (apply 'solar-time-string (cadr l)))
									   "no sunset")
			(nth 2 l)))
  )
;; To be called from diary-list-sexp-entries, where DATE is bound.
;;;###diary-autoload
(defun diary-sunset ()
  "Local time of sunset as a diary entry.
		Accurate to a few seconds."
  (or (and calendar-latitude
		   calendar-longitude
		   calendar-time-zone
		   )
	  (soLar-setup)
	  )
  (solar-sunset-string date)
  )

(defun skx-org-mode-before-save-hook ()
  (when (eq major-mode 'org-mode)
	(skx/update-org-modified-property))
  )


(use-package affe
  :config
  (setq affe-count 500
		affe-find-command ;; "fd "
		"rg  --color=never --files"
		)
  )

(use-package fussy
  :config
  ;; (push 'fussy completion-styles)
  (setq
   ;; For example, project-find-file uses 'project-files which uses
   ;; substring completion by default. Set to nil to make sure it's using
   ;; flx.
   completion-category-defaults nil
   completion-category-overrides nil)
  )

(use-package notmuch)

(defun exec/get-url-title (url)
  "Retrieve the title of the webpage at URL."
  (let ((buffer (url-retrieve-synchronously url)))
	(unwind-protect
		(with-current-buffer buffer
		  (goto-char (point-min))
		  (re-search-forward "<title>\\(.+\\)</title>")
		  (match-string 1))
	  (kill-buffer buffer))))

(defun exec/markdown-link-from-clipboard ()
  "Generate a markdown link from the URL in the clipboard."
  (interactive)
  (let* ((url (current-kill 0))
		 (title (exec/get-url-title url)))
	(insert (format "[%s](%s)" title url))))

;; (use-package markdown-mode
;;   :config
;;   (setq markdown-fontify-code-blocks-natively t)
;;   )

(use-package hackernews
  :config
  (setq hackernews-items-per-page 50)

  )

(setq epg-pinentry-mode 'loopback)
(epa-file-enable)

(use-package pinentry
  :config (pinentry-start))

(use-package org
  ;;   :hook (
  ;; 		 (before-save . skx-org-mode-before-save-hook)
  ;; 		 (org-trigger . save-buffer)
  ;; 		 )
  :custom-face
  (org-level-1 ((t (:height 1.5))))
  (org-level-2 ((t (:height 1.3))))
  (org-level-3 ((t (:height 1.1))))
  :config

  ;; (org-crypt-use-before-save-magic)
  ;; (setq org-crypt-key "0F0272C0D3AC91F7")
  ;; (setq org-tags-exclude-from-inheritance (quote ("crypt")))


  (setq org-startup-folded
		;; 'content
		'showeverything
		)
  (setq org-use-fast-todo-selection 'expert)

  (setq org-startup-truncated   nil)
	  ;;;;;;; org-agenda-begin
  (setq org-log-done  'time)
  ;; (setq org-agenda-files
  ;; 	  (directory-files-recursively "~/org/" "\.org$")
  ;; 	  )
  (setq org-agenda-files
		(append (directory-files-recursively "~/org/GTD/" "\.org$")
				(directory-files-recursively "~/org/personal/" "\.org$")
				(directory-files-recursively "~/org/work/" "\.org$")
				(directory-files-recursively "~/org/notes/" "\.org$")
				(directory-files-recursively "~/org/journal/" "\.org$")))

  (setq org-habit-preceding-days 21
		org-habit-following-days 7
		org-habit-graph-column 54
		org-habit-show-habits-only-for-today nil
		)
  ;; (org-agenda-include-diary . t)
  (setq org-agenda-time-grid '((daily today require-timed)
							   (000 100 200 300 400 500 600 700 800 900 1000 1100 1200 1300 1400 1500 1600 1700 1800 1900 2000 2100 2200 2300 2400)
							   "......"
							   "----------------"))
  (setq org-done-keywords-for-agenda nil)
  (setq org-agenda-use-tag-inheritance  t)
  (setq org-agenda-window-setup 'current-window)
  (setq org-agenda-restore-windows-after-quit  t)
  (setq org-agenda-start-on-weekday nil
		org-agenda-time-leading-zero t
		org-agenda-log-mode-items '(closed clock state)
		)

  (setq-local transient-force-fixed-pitch t)
  (transient-define-prefix exec/org-agenda-transient ()
	"Replace the org-agenda buffer by a transient."
	[["Built-in agendas"
	  ("a" "Agenda for current week or day" (lambda () (interactive) (org-agenda nil "a")))
	  ("t" "List of all TODO entries" (lambda () (interactive) (org-agenda nil "t")))
	  ("T" "Entries with special TODO kwd" (lambda () (interactive) (org-agenda nil "T")))
	  ("m" "Match a TAGS/PROP/TODO query" (lambda () (interactive) (org-agenda nil "m")))
	  ("M" "Like m, but only TODO entries" (lambda () (interactive) (org-agenda nil "M")))
	  ("e" "Expport agenda views" (lambda () (interactive) (org-agenda nil "e")))
	  ("s" "Search for keywords" (lambda () (interactive) (org-agenda nil "s")))
	  ("S" "Like s, but only TODO entries" (lambda () (interactive) (org-agenda nil "S")))
	  ("/" "Multi-occur" (lambda () (interactive) (org-agenda nil "/")))
	  ("<" "Buffer, subtree/region restriciton" (lambda () (interactive) (org-agenda nil "<")))
	  (">" "Remove restriction" (lambda () (interactive) (org-agenda nil ">")))
	  ("#" "List stuck projects (!=configure)" (lambda () (interactive) (org-agenda nil "#")))
	  ("!" "Define \"stuck\"" (lambda () (interactive) (org-agenda nil "!")))
	  ("C" "Configure custom agenda commands" (lambda () (interactive) (org-agenda nil "C")))]
	 ["Custom agendas"
	  ("A" "Daily and overview" (lambda () (interactive) (org-agenda nil "A")))
	  ("H" "Habits tracker" (lambda () (interactive) (org-agenda nil "H")))]])



	  ;;;;;;; org-agenda-end
  (setq org-startup-with-inline-images t)
  (setq org-tag-beautify-mode  t)
  (setq org-confirm-babel-evaluate  t)
  (setq org-return-follows-link   t)
  (setq org-enforce-todo-dependencies  t)
  (setq org-enforce-todo-checkbox-dependencies  t)
  (setq org-startup-with-inline-images t)
  (setq org-display-inline-images t)
  (setq org-redisplay-inline-images t)
  (setq org-startup-with-inline-images "inlineimages")
  (setq org-confirm-babel-evaluate nil)
  (setq org-ellipsis
		;; "⭍"
		"⤵"
		)
  (setq org-default-notes-file  "~/org/notes/")
  (setq org-capture-templates '(
								("w" "work" entry
								 (file+headline  "~/org/GTD/work.org" "WORK" )
								 "** TODO [#B] %i %?
		%T
		")
								("p" "personal stuff" entry (file+headline "~/org/personal/personal.org" "Personl")
								 "* TODO %i %?")
								("e" "EXEC" plain (file+headline "~/org/GTD/personal.org" "EXEC") "** %i %?")

								))
  (setq org-todo-keywords
		'((sequence "TODO(t)" "STARTED" "|" "SKIP(s)" "CANCEL(c)" "DONE(d)")
		  (sequence "REPORT(r)" "BUG(b)" "KNOWNCAUSE(k)" "|" "FIXED(f)")
		  ))

  (defface org-link-id
	'((t :foreground "#50fa7b"
		 :weight bold
		 :underline t))
	"Face for Org-Mode links starting with id:."
	:group 'org-faces)
  (defface org-link-file
	'((t :foreground "#ff5555"
		 :weight bold
		 :underline t))
	"Face for Org-Mode links starting with file:."
	:group 'org-faces)
  (org-link-set-parameters
   "id"
   :face 'org-link-id)
  (org-link-set-parameters
   "file"
   :face 'org-link-file)

  (use-package org-super-agenda
	)

  (use-package org-ql)

  (use-package ob-mermaid
	:config
	(setq ob-mermaid-cli-path "/usr/bin/mmdc"))

  ;; (use-package org-templ)

  (use-package ftable)
  (use-package org-preview-html)
  (use-package org-superstar
	;; :hook (org-mode . org-superstar-mode)
	:config (setq org-hide-leading-stars nil)
	(setq org-superstar-leading-bullet ?\s)
	(setq org-indent-mode-turns-on-hiding-stars nil)
	(setq org-superstar-special-todo-items t))
  (use-package org-cliplink
	:after org)

  (use-package org-modern
	:after org
	:config
	(global-org-modern-mode)
	(set-face-attribute 'org-modern-symbol nil
						:height 1.0
						:family "Iosevka")
	)
  (use-package svg-tag-mode)


  (use-package org-fancy-priorities
	:after org
	;; :hook
	;; org-fanci-priority looks not good, I don't like it
	;; (org-mode . org-fancy-priorities-mode)
	:config
	(setq org-lowest-priority  69)
	(setq org-fancy-priorities-list '("🅰" "🅱" "🅲" "🅳" "🅴"))
	)

  (setq org-babel-hash-show-time t)
  (use-package ob-go)
  (use-package ob-rust)

  ;; active Babel languages
  (org-babel-do-load-languages
   'org-babel-load-languages
   '(
	 (C . t)
	 (gnuplot . t)
	 (mermaid . t)
	 (shell . t)
	 (rust . t)
	 )
   )


  (use-package org-download
	:config

	(setq org-download-method
		  ;; 'attach
		  'directory
		  org-download-screenshot-method "flameshot gui -d 1000 --raw > %s"
		  )
	)
  (use-package org-present)
  ;; (use-package org-ref)

  (use-package org-noter
	:config
	)


  (use-package org-journal
	:config
	(setq org-journal-dir  "~/org/journal/")
	(setq org-journal-date-format   "%F, %A")
	(setq org-journal-time-format  "%T ")
	(setq org-journal-file-format  "%Y.org")  ; their file names
	(setq org-journal-file-type  'yearly)
	(setq org-journal-enable-agenda-integration  t)
	(setq org-journal-enable-cache  t)
	(setq org-journal-carryover-items ""
		  org-journal-prefix-key nil
		  )
	)
  (use-package org-yaap
	:straight (org-yaap :type git :host gitlab :repo "tygrdev/org-yaap")
	:config
	(setq org-yaap-todo-only t
		  org-yaap-alert-before 10
		  org-yaap-daily-alert 6
		  org-yaap-persistent-clock t
		  )
	;; (org-yaap-mode 1)
	)
  )

(defun exec/visual-select-region()
  "Get the whole string,  and current cursor position is in the string, which start by '-----BEGIN PGP MESSAGE-----'  and end with '-----END PGP MESSAGE-----', get the string to a variable"
  (interactive)
  (let ((start (re-search-backward "-----BEGIN PGP MESSAGE-----"))
		(end (re-search-forward "-----END PGP MESSAGE-----")))
	;; get the string between start and end
	(let ((encrypt_string (buffer-substring-no-properties start end)))
	  (with-output-to-temp-buffer "*Temp*"
		(set-buffer standard-output)
		(insert
		 (epg-decrypt-string (epg-make-context 'OpenPGP) encrypt_string)
		 )
		(epa-info-mode))
	  ;; focus to that newly created buffer
	  )
	)
  )




(use-package alarm-clock
  :config
  (setq alarm-clock-play-sound-repeat 3)
  )

(use-package ag)
(use-package vagrant)

(use-package uwu-theme)
(use-package ef-themes)
(use-package atom-dark-theme)

(use-package hl-todo
  :config (hl-todo-mode))

(defun exec/look-up-dict (word)
  "Start goldendict program.  Find WORD."
  (start-process "goldendict" nil "goldendict" word)
  )

(defun exec/look-up-dict-at-point()
  (interactive)
  (let ((word ""))
	(if (equal major-mode 'pdf-view-mode)
		(setq word (car (pdf-view-active-region-text)))
	  (setq word  (thing-at-point 'word' ':no-properties) ))
	(exec/look-up-dict word)
	)
  )

(defun exec/prompt-dict()
  "Prompt for a word and look it up in goldendict."
  (interactive)
  (exec/look-up-dict (read-string "Translate what?: ")))



(use-package bing-dict)
;; good morning
(use-package fanyi
  :custom
  (fanyi-providers   '(
					   fanyi-haici-provider
					   fanyi-etymon-provider
					   fanyi-youdao-thesaurus-provider
					   fanyi-longman-provider
					   ;; fanyi-libre-provider
					   ))
  :config
  )

(defun exec/go-translate-mode-no-mono()
  (interactive)
  (setq-local buffer-face-mode-face '(:family "Noto Sans"))
  (buffer-face-mode))

(use-package go-translate
  :config
  (setq gts-translate-list '(("en" "zh")))
  (setq-default gts-pin-posframe-bdcolor "#ffffff"
				gts-pop-posframe-backcolor "#0f0f0f"
				)
  (setq gts-default-translator
		(gts-translator
		 :picker (gts-prompt-picker)
		 :engines (list
				   (gts-google-engine)
				   ;; (gts-bing-engine)
				   ;; (gts-google-rpc-engine)
				   )
		 :render (
				  ;; gts-buffer-render
				  ;; gts-posframe-pin-render
				  gts-posframe-pop-render
				  )))

  (defun exec/translate()
	(interactive)
	(gts-translate (gts-translator
					:picker (gts-noprompt-picker)
					:engines (gts-stardict-engine)
					:render (gts-posframe-pop-render
							 :height 100
							 :width 200
							 :backcolor "#323d3d"
							 :forecolor "white"
							 )
					)))

  ;; (add-hook 'gts-after-buffer-render-hook ;; use 'gts-after-buffer-multiple-render-hook instead if you have multiple engines
  ;; 			(defun your-hook-that-disable-evil-mode-in-go-translate-buffer (&rest _)
  ;; 			  (evil-emacs-state)
  ;; 			  (exec/go-translate-mode-no-mono)
  ;; 			  ))
  )


(use-package org-roam
  :init
  (setq org-roam-directory "~/org/roam/"
		org-roam-db-location "~/.cache/org-roam/org-roam.db")
  :config
  (setq org-roam-extract-new-file-path "${slug}-%<%Y%m%d%H%M%S>.org"
		org-roam-completion-everywhere nil
		org-roam-completion-functions '(
										org-roam-complete-link-at-point
										org-roam-complete-everywhere
										)
		)
  (setq org-roam-node-display-template` "${title:*} ${tags:30}")
  ;; default is "${title:*} ${tags:10}"
  ;; remove :* and :10
  (setq
   org-roam-dailies-directory "dailies/"
   org-roam-db-gc-threshold most-positive-fixnum
   org-roam-mode-section-functions (list #'org-roam-backlinks-section
										 #'org-roam-reflinks-section
										 ;; #'org-roam-unlinked-references-section
										 )
   org-roam-capture-templates '(("d" "default" plain "%?"
								 :if-new (file+head "${slug}-%<%Y%m%d%H%M%S>.org"
													"#+TITLE: ${title}
#+FILETAGS:
#+CREATED_AT: %u
#+LAST_MODIFIED: <>
") :unnarrowed t)))

  (org-roam-db-autosync-mode))


(use-package org-attach-screenshot)

(use-package org-roam-ui
  :after org-roam ;; or :after org
  ;;         normally we'd recommend hooking orui after org-roam, but since org-roam does not have
  ;;         a hookable mode anymore, you're advised to pick something yourself
  ;;         if you don't care about startup time, use
  ;;  :hook (after-init . org-roam-ui-mode)
  :config
  (setq org-roam-ui-sync-theme t
		org-roam-ui-follow t
		org-roam-ui-update-on-save t
		org-roam-ui-open-on-start t))



(use-package websocket)

(use-package hyperbole
  :config
  (hyperbole-mode -1)
  )

(use-package dumb-jump
  :hook(
		(xref-backend-functions . dumb-jump-xref-activate)
		)
  :config
  )

(use-package org-download
  :after org
  :hook (org-mode . org-download-enable)
  :config (setq-default org-download-image-dir "~/Pictures/org/"))

(use-package makefile-executor
  :hook (projectile-mode . makefile-executor-mode)
  :config
  )


(use-package engine-mode
  :demand t
  :config
  (defengine github
	"https://github.com/search?ref=simplesearch&q=%s&type=code"
	:keybinding "c"
	)
  (defengine google
	"https://www.google.com/search?ie=utf-8&oe=utf-8&q=%s"
	:keybinding "g"
	)
  (defengine wikipedia
	"https://www.wikipedia.org/search-redirect.php?language=en&go=Go&search=%s"
	:keybinding "w"
	:docstring "Searchin' the wikis.")

  (defengine nixpkgs
	"https://search.nixos.org/packages?query=%s"
	:keybinding "n"
	:docstring "Searchin the nixos pkgs")

  (engine-mode t))

(use-package yeetube
  :config
  (setq yeetube-mpv-disable-video t
		yeetube-download-directory "~/Music"
		yeetube-download-audio-format "m4a"
		yeetube-results-limit 25)

  (general-define-key
   :keymaps 'yeetube-mode-map
   "<return>" 'yeetube-play
   )
  )

(use-package empv
  :straight (:host github :repo "isamert/empv.el")
  :config
  (setq empv-invidious-instance "https://vid.puffyan.us/api/v1"
		empv-youtube-use-tabulated-results t
		empv-youtube-thumbnail-quality "default"
		)
  )

(use-package projectile
  :bind("C-c p" . projectile-command-map)
  :config
  (setq projectile-auto-discover nil)
  (setq projectile-current-project-on-switch 'keep)
  (setq projectile-indexing-method 'hybrid)
  (setq projectile-enable-caching nil)
  (setq projectile-project-enable-cmd-caching nil)
  (setq projectile-per-project-compilation-buffer t)
  (setq projectile-ignored-projects '(
									  "~/.emacs.d/"
									  )
		projectile-auto-update-cache t

		;; projectile-switch-project-action 'consult-projectile-find-file
		projectile-switch-project-action 'exec/dired-current-directory
		projectile-project-search-path '(( "~/Projects" . 3))
		)
  (defun projectile-project-current (dir)
	"Retrieve the root directory of the project at DIR using `project-current'."
	(cdr (project-current nil dir)))
  (setq
   projectile-project-root-functions '(
									   ;; projectile-project-current
									   projectile-root-local
									   projectile-root-marked
									   projectile-root-bottom-up
									   projectile-root-top-down
									   projectile-root-top-down-recurring))
  (defun projectile-ignored-project-function(project-root)
	(or (string-prefix-p "~/.emacs.d/" project-root)
		(string-prefix-p "~/.cargo/" project-root)
		(string-prefix-p "~/.rustup/" project-root)
		(string-prefix-p "/nix/store/" project-root)
		)
	)
  ;; bind consult-projectile-find-file to C-c p f use general

  (defun projectile-compile--double-prefix-means-run-comint (func &optional args)
    "allow running compilation interactively when multiple prefixes are given.
		with two prefixes (C-u C-u) runs default compilation command in interactive
		compilation buffer. with three prompts for command and then runs it in an
		interactive compilation buffer."
    (let ((prefix current-prefix-arg))
	  (if (and (consp prefix)
			   (setq prefix (car prefix))
			   (>= prefix 16))
		  (cl-letf* (((symbol-function 'actual-compile)
					  (symbol-function 'compile))
                     ((symbol-function 'compile)
					  (lambda (command &optional comint)
                        (actual-compile command t))))
            (funcall func (if (eq prefix 16) nil '(4))))
        (funcall func prefix))))

  (advice-add 'projectile-run-project     :around #'projectile-compile--double-prefix-means-run-comint)
  (advice-add 'projectile-compile-project :around #'projectile-compile--double-prefix-means-run-comint)
  (advice-add 'projectile-test-project    :around #'projectile-compile--double-prefix-means-run-comint)

  (projectile-update-project-type
   'rust-cargo
   :related-files-fn
   (list
	(projectile-related-files-fn-test-with-suffix "toml" "Toml")
	(projectile-related-files-fn-test-with-suffix "lock" "Lock"))
   :test-prefix nil
   :precedence 'high)

  (defun exec/projectile-open-all-buffers()
	(interactive)

	;; get all fiels by projectile-dir-files, if it's `.rs' file, and open them
	(let ((files (projectile-dir-files (projectile-project-root))))
	  (dolist (file files)
		(if (string-suffix-p ".rs" file)
			(let ((pathfile (concat  (projectile-project-root) file)))
			  (message "opening %s" pathfile)
			  (find-file  pathfile)
			  )
		  )
		)
	  ))



  (use-package projectile-ripgrep)

  (projectile-mode)
  (defun exec/projectile-mode-hook()
	(interactive)
	(add-to-list 'compilation-search-path (projectile-project-root))
	)

  (add-hook 'projectile-mode-hook #'exec/projectile-mode-hook)

  )

(use-package cus-dir
  :straight (cus-dir :type git :host gitlab :repo "mauroaranda/cus-dir")
  )



;; Configure Tempel
(use-package tempel
  ;; Require trigger prefix before template name when completing.
  ;; :custom
  ;; (tempel-trigger-prefix "<")

  :bind (("M-+" . tempel-complete) ;; Alternative tempel-expand
         ("M-*" . tempel-insert))

  :init

  ;; Setup completion at point
  (defun tempel-setup-capf ()
    ;; Add the Tempel Capf to `completion-at-point-functions'.
    ;; `tempel-expand' only triggers on exact matches. Alternatively use
    ;; `tempel-complete' if you want to see all matches, but then you
    ;; should also configure `tempel-trigger-prefix', such that Tempel
    ;; does not trigger too often when you don't expect it. NOTE: We add
    ;; `tempel-expand' *before* the main programming mode Capf, such
    ;; that it will be tried first.
    (setq-local completion-at-point-functions
                (cons #'tempel-expand
					  completion-at-point-functions)))

  (add-hook 'prog-mode-hook 'tempel-setup-capf)
  (add-hook 'text-mode-hook 'tempel-setup-capf)

  ;; Optionally make the Tempel templates available to Abbrev,
  ;; either locally or globally. `expand-abbrev' is bound to C-x '.
  ;; (add-hook 'prog-mode-hook #'tempel-abbrev-mode)
  ;; (global-tempel-abbrev-mode)
  )

;; Optional: Add tempel-collection.
;; The package is young and doesn't have comprehensive coverage.
(use-package tempel-collection)

;; based on http://emacsredux.com/blog/2013/04/03/delete-file-and-buffer/
(defun exec/delete-file-and-buffer ()
  "Kill the current buffer and deletes the file it is visiting."
  (interactive)
  (let ((filename (buffer-file-name)))
    (if filename
        (if (y-or-n-p (concat "Do you really want to delete file " filename " ?"))
            (progn
			  (delete-file filename)
			  (message "Deleted file %s." filename)
			  (kill-buffer)))
	  (message "Not a file visiting buffer!"))))

(use-package treemacs
  ;; :disabled t
  ;; :init (with-eval-after-load 'winum (define-key winum-keymap (kbd "M-0") #'treemacs-select-window))
  ;; :init (with-eval-after-load 'winum (evil-leader/set-key "n" 'treemacs-select-window))
  :init
  (defun exec/open-treemacs-no-focus()
	(interactive)
	(treemacs)
	(treemacs-select-window))

  :hook
  (treemacs-mode . exec/decrease-buffer-font)
  :config
  (defun exec/treemacs-set-narrow-font()
	(set-face-attribute 'treemacs-root-face nil :family "Iosevka" )
	(set-face-attribute 'treemacs-directory-face nil :family "Iosevka")
	(set-face-attribute 'treemacs-file-face nil :family "Iosevka")
	(set-face-attribute 'treemacs-git-modified-face nil :family "Iosevka" )
	(set-face-attribute 'treemacs-git-untracked-face nil :family "Iosevka")
	)
  ;; (add-hook 'treemacs-mode-hook 'exec/treemacs-set-narrow-font)

  ;; delay related stuff
  (setq
   treemacs-deferred-git-apply-delay  0.7
   treemacs-file-event-delay          0.7
   treemacs-file-follow-delay         0.7
   treemacs-tag-follow-delay          0.7
   )

  (progn
	(setq treemacs-collapse-dirs                 (if treemacs-python-executable 3 0)
		  treemacs-directory-name-transformer  #'identity
		  treemacs-display-in-side-window        t
		  treemacs-eldoc-display t
		  treemacs-file-extension-regex treemacs-last-period-regex-value
		  treemacs-file-name-transformer         #'identity
		  treemacs-follow-after-init t
		  treemacs-expand-after-init             t
		  treemacs-git-command-pipe ""
		  treemacs-goto-tag-strategy             'refetch-index
		  treemacs-indentation 1
		  treemacs-indentation-string            " "
		  treemacs-is-never-other-window        t
		  treemacs-max-git-entries               5000
		  treemacs-missing-project-action 'ask
		  treemacs-move-forward-on-expand        nil
		  treemacs-no-png-images nil
		  treemacs-no-delete-other-windows       t
		  treemacs-project-follow-cleanup nil
		  treemacs-persist-file                  (expand-file-name ".cache/treemacs-persist"
																   user-emacs-directory)
		  treemacs-position                      'left
		  treemacs-read-string-input 'from-child-frame
		  treemacs-recenter-distance  0.1
		  treemacs-recenter-after-file-follow    'on-distance
		  treemacs-recenter-after-tag-follow nil
		  treemacs-recenter-after-project-jump   'always
		  treemacs-recenter-after-project-expand 'on-distance
		  treemacs-litter-directories  '("/node_modules" "/.venv" "/.cask")
		  treemacs-show-cursor                   nil
		  treemacs-show-hidden-files             t
		  treemacs-silent-filewatch nil
		  treemacs-silent-refresh                nil
		  treemacs-sorting 'alphabetic-asc
		  treemacs-space-between-root-nodes      t
		  treemacs-tag-follow-cleanup            t
		  treemacs-user-mode-line-format         nil
		  treemacs-user-header-line-format       nil
		  treemacs-width                         25
		  treemacs-workspace-switch-cleanup      nil
		  treemacs-silent-refresh t
		  treemacs-silent-filewatch t
		  )

	;; The default width and height of the icons is 22 pixels. If you are
	;; using a Hi-DPI display, uncomment this to double the icon size.
	;;(treemacs-resize-icons 44)
	(treemacs-follow-mode t)
	(treemacs-project-follow-mode t)
	(setq treemacs--project-follow-delay 0.1)
	(treemacs-filewatch-mode t)
	(treemacs-fringe-indicator-mode 'always)
	(pcase (cons (not (null (executable-find "git")))
				 (not (null treemacs-python-executable)))
	  (`(t . t)
	   (treemacs-git-mode 'deferred))
	  (`(t . _)
	   (treemacs-git-mode 'simple)))
	(treemacs-hide-gitignored-files-mode t)
	)
  :bind(
		("C-c t 1"   . treemacs-delete-other-windows)
		("C-c t t"   . treemacs)
		("C-c t d"   . treemacs-display-current-project-exclusively)
		("C-c t B"   . treemacs-bookmark)
		("C-c t C-t" . treemacs-find-file)
		("C-c t M-t" . treemacs-find-tag))

  )

(use-package treemacs-all-the-icons
  :after treemacs
  :config
  (treemacs-load-theme 'all-the-icons)
  )

(use-package treemacs-tab-bar
  :disabled t
  )


;; (use-package treemacs-icons-dired
;;   :hook (treemacs-mode . treemacs-icons-dired-mode))




(use-package treemacs-evil
  :disabled t
  :after (evil treemacs)
  )




(use-package treemacs-projectile
  :config

  )

(setopt consult-projectile-use-projectile-switch-project t)
(add-hook 'projectile-after-switch-project-hook 'exec/open-treemacs-no-focus)


(use-package treemacs-magit
  :disabled t
  :after (treemacs magit)
  )


(use-package tab-bar
  ;; :init

  ;; (defun exec/tab-bar-mode-hook()
  ;; 	(interactive)
  ;; 	(setq
  ;; 	 tab-bar-format '(
  ;; 					  tab-bar-format-menu-bar
  ;; 					  tab-bar-format-history
  ;; 					  tab-bar-format-tabs-groups
  ;; 					  ;; tab-bar-format-tabs
  ;; 					  tab-bar-separator
  ;; 					  tab-bar-format-add-tab
  ;; 					  tab-bar-format-align-right
  ;; 					  tab-bar-format-global
  ;; 					  ))

  ;; 	(setq tab-bar-format (delete-dups tab-bar-format))
  ;; 	)

  ;; (defun exec/name-tab-by-project-or-default ()
  ;; 	"Return project name if in a project, or default tab-bar name if not.
  ;; 		The default tab-bar name uses the buffer name."
  ;; 	(let ((project-name (projectile-project-name)))
  ;; 	  (if (string= "-" project-name)
  ;; 		  (tab-bar-tab-name-current)
  ;; 		(projectile-project-name))))

  ;; (defun exec/tab-bar-project-name(tab_name &optional)
  ;; 	(projectile-project-name)
  ;; 	)
  :custom
  (tab-bar-format  '(tab-bar-format-menu-bar
					 tab-bar-format-history
					 tab-bar-format-tabs
					 tab-bar-separator
					 tab-bar-format-add-tab
					 tab-bar-separator
					 tab-bar-format-align-right
					 tab-bar-format-global
					 )
				   )

  :hook
  (after-init . tab-bar-mode)
  ;; (after-init . tab-bar-history-mode)
  ;; (tab-bar-mode . exec/tab-bar-mode-hook)
  :custom-face
  (tab-bar ((t (:height 1.0))))
  :config
  ;; (setq tab-bar-close-button-show nil
  ;; 		tab-bar-separator " "
  ;; 		tab-bar-border 0
  ;; 		tab-bar-button-margin 0
  ;; 		tab-bar-auto-width nil
  ;; 		tab-bar-tab-name-function 'tab-bar-tab-name-current
  ;; 		;; tab-bar-tab-group-function 'exec/tab-bar-project-name
  ;; 		tab-bar-new-tab-choice "*scratch*"
  ;; 		tab-bar-new-tab-group  'projectile-project-name
  ;; 		)
  ;; (setq tab-bar-format (delete-dups tab-bar-format))

  ;; (add-hook 'persp-before-deactivate-functions
  ;;           (defun +workspaces-save-tab-bar-data-h (_)
  ;;             (when (get-current-persp)
  ;;               (set-persp-parameter
  ;;                'tab-bar-tabs (tab-bar-tabs)))))

  ;; (add-hook 'persp-activated-functions
  ;;           (defun +workspaces-load-tab-bar-data-h (_)
  ;;             (tab-bar-tabs-set (persp-parameter 'tab-bar-tabs))
  ;;             (tab-bar--update-tab-bar-lines t))))

  (funcall tab-bar-tab-name-function)
  (dolist (tab  (funcall tab-bar-tabs-function))
	(message "tab: %s\n" tab)
	)

  (defun exec/tab-bar-new-tab-choice()
	(interactive)
	(scratch-buffer)
	(consult-projectile-switch-project)
	"*scratch*"
	)

  (defun exec/tab-bar-tab-name-function-default()
	(projectile-project-name)
	)
  (let ((tabs (frame-parameter (window-frame) 'tabs)))
    (if tabs
        (let* ((current-tab (tab-bar--current-tab-find tabs))
               (current-tab-name (assq 'name current-tab))
               (current-tab-explicit-name (assq 'explicit-name current-tab)))
          (when (and current-tab-name
                     current-tab-explicit-name
                     (not (cdr current-tab-explicit-name)))
            (setf (cdr current-tab-name)
                  (funcall tab-bar-tab-name-function))))
      ;; Create default tabs
      (setq tabs (list (tab-bar--current-tab-make)))
      (tab-bar-tabs-set tabs frame))
    tabs)

  (setq tab-bar-auto-width nil
		tab-bar-close-button-show nil
		tab-bar-new-tab-choice #'exec/tab-bar-new-tab-choice
		tab-bar-new-tab-group nil
		tab-bar-new-tab-to 'rightmost
		tab-bar-tab-name-function
		#'exec/tab-bar-tab-name-function-default
		)
  )

(use-package tab-line
  :straight (:type built-in)
  :custom-face
  (tab-line ((t (:background "black" :height 0.9))))
  (tab-line-tab ((t (:height 0.9))))
  (tab-line-tab-inactive ((t (:inherit tab-line))))
  (tab-line-tab-modified ((t (:inherit tab-line :foreground "pink" :background "black" :height 0.9))))
  (tab-line-tab-current ((t (:inherit tab-line :weight bold :background "black" :foreground "green"))))
  :config

  (defun exec/tab-line-buffer-group (buffer)
	"Use the project.el name for the buffer group"
	(with-current-buffer buffer
	  (s-chop-suffix "/" (projectile-project-root))))

  (defun exec/buffer-sort (a b)
	(string< (buffer-name a) (buffer-name b)))

  (defun exec/tab-line-tabs-function()
	(if (projectile-project-p)
		(projectile-project-buffers)
	  (tab-line-tabs-buffer-list))
	)

  (setq tab-line-close-button-show nil
		tab-line-switch-cycling t
		tab-line-left-button nil
		tab-line-right-button nil
		tab-line-auto-hscroll t
		tab-line-close-tab-function 'kill-buffer
		tab-line-separator "|"
		tab-line-tabs-buffer-group-sort-function #'exec/buffer-sort
		tab-line-tabs-buffer-group-function #'exec/tab-line-buffer-group
		tab-line-tabs-buffer-list-function #'tab-line-tabs-buffer-list
		tab-line-tabs-function
		#'exec/tab-line-tabs-function
		;; 'projectile-project-buffers
		;; 'tab-line-tabs-window-buffers
		;; 'tab-line-tabs-buffer-list
		tab-line-exclude-modes '(w3m-mode completion-list-mode)
		)

  (defun exec/tab-line-tab-name (cand &optional _buffers)
	"Generate tab name from BUFFER.
Reduce tab width proportionally to space taken by other tabs.
This function can be overridden by changing the default value of the
variable `tab-line-tab-name-function'."
	;; (concat (nerd-icons-icon-for-buffer buffer)
	;; 		(buffer-name buffer))
	(let* ((mode (buffer-local-value 'major-mode (get-buffer cand)))
		   (icon (nerd-icons-icon-for-mode mode))
		   (parent-icon (nerd-icons-icon-for-mode
						 (get mode 'derived-mode-parent))))
	  (concat
	   (if (symbolp icon)
		   (if (symbolp parent-icon)
			   (nerd-icons-faicon "nf-fa-sticky_note_o")
			 parent-icon)
		 icon)
	   " "
	   (buffer-name cand)))
	)

  (setq tab-line-tab-name-function 'exec/tab-line-tab-name)


  (global-tab-line-mode)
  )

(use-package intuitive-tab-line
  :disabled
  :straight (:host github :repo "thread314/intuitive-tab-line-mode")
  :custom
  (tab-line-tabs-function 'intuitive-tab-line-buffers-list)
  )



(use-package centaur-tabs
  :disabled t
  ;; :demand t
  ;; :hook
  ;; (vertico-buffer-mode . centaur-tabs-local-mode)
  :bind
  (:map evil-normal-state-map
        ("g t" . centaur-tabs-forward)
        ("g T" . centaur-tabs-backward))
  :config
  (setq
   centaur-tabs-set-icons t
   centaur-tabs-set-close-button nil
   centaur-tabs-set-bar 'over
   centaur-tabs-set-modified-marker t
   centaur-tabs-background-color "black"
   centaur-tabs-height 32
   centaur-tabs-icon-scale-factor 1.2
   )
  (set-face-attribute 'centaur-tabs-selected nil :weight 'normal)
  (set-face-attribute 'centaur-tabs-selected-modified nil :weight 'normal)
  (set-face-attribute 'centaur-tabs-unselected nil :weight 'normal)
  (set-face-attribute 'centaur-tabs-unselected-modified nil :weight 'normal)


  (centaur-tabs-mode)
  (centaur-tabs-headline-match)
  ;; (centaur-tabs-change-fonts "JuliaMono" 1.0)
  )


;; (defvar mode-line-cleaner-alist
;;   `(
;; 	(yas-minor-mode . " υ")
;; 	(paredit-mode . " π")
;; 	(eldoc-mode . "")
;; 	(abbrev-mode . "")
;; 	;; Major modes
;; 	(lisp-interaction-mode . " λ")
;; 	(hi-lock-mode . "")
;; 	(python-mode . " Py")
;; 	(git-gutter-mode . " G")
;; 	(projectile-mode . " P")
;; 	(emacs-lisp-mode . " EL")
;; 	(nxhtml-mode . " nx"))
;;   "Alist for `clean-mode-line'.

;; When you add a new element to the alist, keep in mind that you
;; must pass the correct minor/major mode symbol and a string you
;; want to use in the modeline *in lieu of* the original.")

(use-package restart-emacs
  :config
  )
(use-package emacs-everywhere)

(defun clean-mode-line ()
  (interactive)
  (cl-loop for cleaner in mode-line-cleaner-alist
		   do (let* ((mode (car cleaner))
					 (mode-str (cdr cleaner))
					 (old-mode-str (cdr (assq mode minor-mode-alist))))
				(when old-mode-str
				  (setcar old-mode-str mode-str))
				;; major mode
				(when (eq mode major-mode)
				  (setq mode-name mode-str)))))


;; (add-hook 'after-change-major-mode-hook 'clean-mode-line)
(use-package dockerfile-mode)
(use-package docker)
(use-package gameoflife)

(use-package minions
  :config
  (minions-mode))

(use-package transpose-frame)

(use-package spaceline-all-the-icons
  :disabled t
  :config
  ;; 'slant, 'arrow, 'cup, 'wave, 'none
  (setq spaceline-all-the-icons-separator-type 'none)
  (setq spaceline-all-the-icons-icon-set-modified 'toggle)
  (setq spaceline-all-the-icons-icon-set-vc-icon-git 'git-name)
  (setq spaceline-all-the-icons-clock-always-visible nil)
  (setq spaceline-all-the-icons-highlight-file-name t)


  (setq spaceline-highlight-face-func 'spaceline-highlight-face-evil-state)
  (spaceline-toggle-all-the-icons-projectile-off)
  (spaceline-toggle-all-the-icons-buffer-id-off)
  (spaceline-all-the-icons-theme)
  (custom-set-faces
   '(spaceline-evil-insert ((t (:background "red" :foreground "#ffffff" :inherit 'mode-line))))
   '(spaceline-evil-normal ((t (:background "green" :foreground "#3E3D31" :inherit 'mode-line))))
   '(spaceline-evil-visual ((t (:background "purple" :foreground "#ffffff" :inherit 'mode-line))))
   )
  )



(use-package paren
  :config
  (set-face-attribute 'show-paren-match nil :box '(:line-width (-1 . -1) :color "red"))

  (setq show-paren-context-when-offscreen 'overlay
		show-paren-style 'parenthesis
		)
  (show-paren-mode))


;; https://www.reddit.com/r/orgmode/comments/z4sb31/go_to_random_line_in_a_file
(defun exec/go-to-random-line ()
  (interactive)
  (goto-line (1+ (random (count-lines (point-min) (point-max)))))
  )


(use-package writeroom-mode
  :bind (:map writeroom-mode-map ("C-M-<" .  writeroom-decrease-width)
			  ("C-M->" .  writeroom-increase-width)
			  ("C-M-=" .  writeroom-adjust-width)
			  )
  :custom (writeroom-width  148))

(use-package parchment-theme)
(use-package atom-one-dark-theme)
(use-package wildcharm-theme)
(use-package tron-legacy-theme)
(use-package kaolin-themes)
(use-package mindre-theme)
(use-package zenburn-theme)
(use-package naga-theme)
(use-package soothe-theme)
(use-package cyberpunk-theme)
(use-package github-theme)
(use-package almost-mono-themes)
(use-package github-dark-vscode-theme)
;; (use-package spacemacs-theme)
(use-package inkpot-theme)
(use-package organic-green-theme)
(use-package nyan-mode)
;; (use-package nasy-theme
;;   :ensure nil
;;   :straight (nasy-theme :type git :host github :repo "nasyxx/emacs-nasy-theme" :files ("*.el")))
;; (use-package matrix-emacs-theme
;;   :straight (matrix-emacs-theme :type git :host github :repo "monkeyjunglejuice/matrix-emacs-theme"))

(use-package diminish
  :config

  )

(use-package doom-modeline
  :disabled
										; :hook
  ;; (after-init . doom-modeline-mode)
  :config
  (setq doom-modeline-battery nil
		doom-modeline-buffer-encoding nil
		doom-modeline-continuous-word-count-modes nil
		doom-modeline-github nil
		doom-modeline-hud nil
		doom-modeline-icon t
		doom-modeline-lsp t
		doom-modeline-minor-modes t
		doom-modeline-buffer-file-name-style 'relative-from-project
		)
  )

(use-package doom-themes
  :config
  (setq
   doom-vibrant-padded-modeline t
   doom-vibrant-brighter-comments nil
   doom-vibrant-brighter-modeline t
   )
  )
(use-package all-the-icons)
(use-package all-the-icons-dired
  ;; :hook (dired-mode . all-the-icons-dired-mode)
  ;; :config
  ;; (setq all-the-icons-dired-monochrome nil)
  )
;; (use-package treemacs-all-the-icons  )

(use-package moe-theme)

(use-package material-theme)

(use-package sublime-themes)

(use-package  hybrid-reverse-theme)

(use-package idea-darkula-theme)
(use-package base16-theme)
;;; load custom theme

(setq custom-theme-allow-multiple-selections nil)

(use-package ayu-theme)

(use-package plan9-theme)
(use-package professional-theme)

(use-package dracula-theme)

(use-package acme-theme)
(use-package inverse-acme-theme)
(use-package nofrils-acme-theme)

(use-package sexy-monochrome-theme)
(use-package which-key
  :config
  ;; Allow C-h to trigger which-key before it is done automatically
  (setq which-key-show-early-on-C-h t)
  (setq which-key-popup-type 'minibuffer)
  (setq which-key-frame-max-width (frame-width))
  (setq which-key-frame-max-height (frame-height))
  (setq which-key-idle-delay 0.3)
  (setq which-key-idle-secondary-delay 0)
  (setq which-key-max-description-length 57)
  (setq which-key-side-window-max-height 0.5)
  (setq which-key-allow-evil-operators t)
  (setq which-key-sort-order
		;; 'which-key-prefix-then-key-order-reverse
		'which-key-description-order

		which-key-dont-use-unicode t
		which-key-ellipsis ".."
		)
  ;; I should bind which-key-show-top-level
  (which-key-mode)

  (defun exec/which-key-show-top-level()
	(interactive)
	(setq-local which-key-sort-order 'which-key-prefix-then-key-order)
	(which-key-show-top-level)
	)
  )


(use-package which-key-posframe
  :init
  :config
  (setq which-key-posframe-poshandler 'posframe-poshandler-frame-bottom-left-corner
		which-key-posframe-border-width 0
		which-key-posframe-font nil
		which-key-is-verbose t)

  (if (display-graphic-p)
	  (which-key-posframe-mode)))




(use-package olivetti
  :config)


(use-package highlight-defined
  :hook
  (emacs-lisp-mode . highlight-defined-mode))

(use-package morlock
  :config
  (global-morlock-mode -1)
  )


(defun exec/white-bg-face()
  (interactive)
  (setq-local buffer-face-mode-face '(
									  :background "white"
									  :foreground "black"
									  ))
  (make-local-variable 'buffer-face-mode-face)
  (buffer-face-mode)
  )
(use-package w3m
  :straight (:type built-in)
  ;; :hook
  ;; (w3m-mode . exec/white-bg-face)
  :config
  (setq w3m-command-environment '(("LC_ALL" . "en_US.UTF-8"))
		w3m-coding-system 'utf-8
		w3m-file-coding-system 'utf-8
		w3m-input-coding-system 'utf-8
		w3m-terminal-coding-system 'utf-8
		w3m-default-display-inline-images t
		w3m-file-name-coding-system 'utf-8
		w3m-home-page "https://en.wikipedia.org/wiki/Special:Random"
		w3m-confirm-leaving-secure-page nil
		w3m-session-load-crashed-sessions t
		w3m-session-load-last-sessions t
		w3m-unsafe-url-warning ""
		)

  )
(use-package eww
  :straight (:type built-in)
  ;; :hook
  ;; (eww-mode . exec/white-bg-face)
  ;; https://www.google.com/search?q=%s&pws=0&gl=us&gws_rd=cr
  ;; https://google.com

  :config
  (setq eww-search-prefix "https://www.google.com/search?pws=0&gl=us&gws_rd=cr&q="
		eww-retrieve-command nil
		browse-url-browser-function 'browse-url-default-browser
		;; 'eww-browse-url
		)
  (defun exec/eww-render-current-buffer ()
	"Render HTML in the current buffer with EWW"
	(interactive)
	(beginning-of-buffer)
	(eww-display-html 'utf8 (buffer-name)))

  ;; (global-set-key (kbd "<C-c C-e C-w C-w>") 'eww-render-current-buffer)

  )

(use-package dired
  :straight (:type built-in)
  ;; :hook
  ;; (dired-mode . dired-filter-mode)
  :bind
  (:map dired-mode-map ("<mouse-2>" . dired-mouse-find-file))
  :config
  (general-nmap :keymaps 'dired-mode-map
	"<mouse-2>"                     'dired-mouse-find-file
	)

  ;; (setq dired-listing-switches "-alFh --group-directories-first --no-group")
  (setq dired-listing-switches
		"-l --almost-all --human-readable --group-directories-first --no-group")

  (setq dired-kill-when-opening-new-dired-buffer t)

  (setq global-auto-revert-non-file-buffers t)
  (setq auto-revert-verbose nil)

  ;; Addtional syntax highlighting for dired
  (use-package diredfl
	:hook
	((dired-mode . diredfl-mode)
	 ;; highlight parent and directory preview as well
	 ;; (dirvish-directory-view-mode . diredfl-mode)
	 )
	:config
	(set-face-attribute 'diredfl-dir-name nil :bold t))
  )

;; (use-package dirvish
;;   :init
;;   (dirvish-override-dired-mode)
;;   (dirvish-side-follow-mode)
;;   :config
;;   (setq dirvish-hide-details t)
;;   (setq dirvish-attributes
;; 		'(vc-state subtree-state
;; 				   all-the-icons
;; 				   ;; collapse
;; 				   ;; git-msg
;; 				   ;; file-time
;; 				   ;; file-size
;; 				   )
;; 		)
;;   (setq dirvish-mode-line-height 20)

;;   )
(use-package dired-x
  :straight (:type built-in)
  :config
  ;; Make dired-omit-mode hide all "dotfiles"
  (setq dired-omit-files "\\|^\\..*$")
  ;; (concat dired-omit-files "\\|^\\..*$"))
  )

(use-package info-colors
  :hook (Info-selection . info-colors-fontify-node)
  )

(use-package expand-region
  :bind ("C-=" . er/expand-region))

(use-package sicp)

(use-package sly
  :init
  (setq-default inferior-lisp-program "/etc/profiles/per-user/exec/bin/sbcl")
  (setq-default sly-net-coding-system 'utf-8-unix)
  :config
  )

;; (use-package slime ;; shouldn't be with sly
;;   :config (setq inferior-lisp-program "sbcl"
;; 				slime-net-coding-system 'utf-8-unix
;; 				)
;;   )

(defun exec/screenshot-svg ()
  "Save a screenshot of the current frame as an SVG image.
  Saves to a temp file and puts the filename in the kill ring."
  (interactive)
  (let* ((filename (make-temp-file "Emacs" nil ".svg"))
		 (data (x-export-frames nil 'svg)))
	(with-temp-file filename (insert data))
	(kill-new filename)
	(message filename))
  )

(use-package origami
  ;; :hook
  ;; (prog-mode . origami-mode)

  :config
  (setq origami-show-fold-header nil)

  )

(use-package ts-fold
  :straight (ts-fold :type git :host github :repo "emacs-tree-sitter/ts-fold")
  :hook
  (prog-mode . ts-fold-mode)
  )

(use-package zen-mode)

(use-package danneskjold-theme)
(use-package flatui-theme)
(use-package twilight-bright-theme )
(use-package simplicity-theme)

(use-package bm
  :config
  )
(use-package sqlup-mode)


(use-package gruvbox-theme)
(use-package vscode-dark-plus-theme)
(use-package solarized-theme)



(defun exec/org-mode-fixed()
  "Set a fixed width (monospace) font in current buffer."
  (interactive)
  (custom-set-faces
   ;;  '(org-verbatim       ((t  (:inherit  org-verbatim      :family "Sarasa Term CL"  :height  1.0))))
   ;;  '(org-formula        ((t  (:inherit  org-table         :family "Sarasa Term CL"  :height  1.0))))
   '(org-modern-symbol  ((t (:family "Iosevka"  :height  1.0))))
   ;;  '(org-block          ((t  (:inherit  org-block         :family "Sarasa Term CL"  :height  1.0))))
   ;;  '(org-table          ((t  (:inherit  org-table         :family "Sarasa Term CL"  :height  1.0))))
   )
  (setq-local buffer-face-mode-face '(:height 1.0))
  (buffer-face-mode))

;; (set-face-attribute 'fixed-pitch nil :family "SomeFont" :inherit 'default)

(defun exec/open-in-tmux()
  (interactive)
  (shell-command (concat "tmux new-window -c \"" default-directory "\""))
  )



;; (add-hook 'prog-mode-hook 'exec/prog-mode-font)
;; (add-hook 'emacs-lisp-mode-hook 'exec/prog-mode-font)

;; (add-hook 'org-mode-hook 'exec/increase-buffer-font)
;; (add-hook 'org-journal-mode-hook 'exec/increase-buffer-font)

(defun exec/prog-mode-font()
  (interactive)
  (setq-local buffer-face-mode-face '(:family "JetbrainsMonoNL"))
  (buffer-face-mode))
;; (add-hook 'prog-mode-hook 'exec/increase-buffer-font)


;; (add-hook 'prog-mode-hook 'display-line-numbers-mode)
;; (add-hook 'text-mode-hook 'display-line-numbers-mode)
;; (add-hook 'toml-mode-hook 'display-line-numbers-mode)
;; (add-hook 'conf-mode-hook 'display-line-numbers-mode)
;; (add-hook 'ssh-config-mode-hook 'display-line-numbers-mode)
;; (add-hook 'consult-preview-at-point-mode-hook 'display-line-numbers-mode)
(add-hook 'prog-mode-hook 'electric-indent-mode)
(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)
(add-hook 'emacs-lisp-mode-hook (lambda ()
								  (add-hook 'local-write-file-hooks
											'check-parens)))



;; (add-hook 'before-save-hook 'delete-trailing-whitespace)

(use-package line-reminder
  :config
  (setq line-reminder-show-option 'indicators)  ; Or set to 'indicators

  ;;  (global-line-reminder-mode)
  )

(use-package deadgrep
  :hook (deadgrep-mode . next-error-follow-minor-mode)
  :config
  (setq
   deadgrep-executable "rg"
   deadgrep-max-buffers nil
   deadgrep-max-line-length 500
   deadgrep-display-buffer-function 'switch-to-buffer
   deadgrep--context '(1 . 1)
   )
  ;; set deadgrep-filename-face to inhirant font-lock-variable-name-face and bold and bigger
  (set-face-attribute 'deadgrep-filename-face nil :inherit 'font-lock-string-face :weight 'bold :height 1.2)

  (evil-define-key 'normal deadgrep-mode-map (kbd "C-j") 'deadgrep-forward-filename)
  (evil-define-key 'normal deadgrep-mode-map (kbd "C-k") 'deadgrep-backward-filename)
  (evil-define-key 'normal deadgrep-mode-map (kbd "C") 'deadgrep-cycle-search-case)
  (evil-define-key 'normal deadgrep-mode-map (kbd "D") 'deadgrep-directory)
  (evil-define-key 'normal deadgrep-mode-map (kbd "^") 'deadgrep-parent-directory)
  (evil-define-key 'normal deadgrep-mode-map (kbd "s") 'deadgrep-search-term)
  (evil-define-key 'normal deadgrep-mode-map (kbd "T") 'deadgrep-cycle-search-type)
  (evil-define-key 'normal deadgrep-mode-map (kbd "p") 'deadgrep-preview-result)

  ;; open a file in a other window, and add "*deadgrep-preview:"
  ;; as the prefix of the buffer name.
  (defun find-file-in-other-window-with-prefix-buffer-name(filename)
	(interactive)
	(let ((buffer-name (concat "*deadgrep-preview:" filename)))
	  (find-file-other-window filename)
	  (rename-buffer buffer-name)))

  (defun exec/deadgrep-posframe-show(file-name)
	(interactive)
	(defconst deadgrep-preview-posframe "*deadgrep-preview-posframe*")
	(posframe-show deadgrep-preview-posframe
				   :string "This is a test"
				   :position (point))

	)

  (defun deadgrep-preview-result()
	"Goto the search result at point, opening it in a specific window which named deadgrep-preview."
	(interactive)
	(deadgrep-visit-result-other-window))
  )

(use-package color-rg
  :straight (color-rg :type git :host github :repo "manateelazycat/color-rg")
  :custom-face
  (color-rg-font-lock-file ((t (:height 0.8))))
  (color-rg-font-lock-match ((t (:foreground "unspecific" :underline (:color "yellow":style wave)))))

  :init
  (defun exec/color-rg-search-project()
	(interactive)
	(setq color-rg-search-project-invoke-file-name buffer-file-name)
	(color-rg-search-project))

  (defun exec/color-rg-search-in-invoke-dir()
	(interactive)
	(setf
	 (color-rg-search-dir color-rg-cur-search)
	 (file-name-directory
	  (directory-file-name
	   color-rg-search-project-invoke-file-name
	   ))
	 )
	(color-rg-rerun)
	)

  :config
  (define-key isearch-mode-map (kbd "M-r") 'isearch-toggle-color-rg)
  (setq color-rg-recenter-match-line t
		color-rg-search-no-ignore-file nil
		)
  (general-nmap 'color-rg-mode-map
	"J" 'color-rg-jump-next-file
	"K" 'color-rg-jump-prev-file
	"P" 'color-rg-rerun-in-project
	"d" 'color-rg-remove-line-from-results
	"D" 'exec/color-rg-search-in-invoke-dir
	)
  )

(use-package blink-search
  :straight (blink-search :type git :host github :repo "manateelazycat/blink-search"
						  :files ("*.el" "*.py" "core" "backend" "icons"))
  :config
  (setq blink-search-enable-posframe t
		blink-search-posframe-standalone nil
		blink-search-posframe-width-ratio 0.9)
  )


(use-package awesome-tray
  :straight (:host github :repo "manateelazycat/awesome-tray")
  :config
  (setq awesome-tray-adjust-mode-line-color-enable t
		awesome-tray-buffer-name-buffer-changed t
		awesome-tray-file-path-show-filename t
		awesome-tray-file-path-full-dirname-levels 3
		awesome-tray-file-path-truncated-name-length 10
		awesome-tray-file-name-max-length 100
		awesome-tray-active-modules '("git" "location-or-page" "buffer-name" "evil" "mode-name" "last-command" "battery" "date")
		awesome-tray-date-format "%m-%d %-H:%M %a"
		)

  ;; (awesome-tray-mode)
  )

(use-package sort-tab
  :disabled
  :straight (:host github :repo "manateelazycat/sort-tab" :files ("*.el"))
  :config
  )

(use-package holo-layer
  :straight (:host github :repo "manateelazycat/holo-layer" :files ("*.el" "*.py" "plugin" "resources"))
  :config
  (setq-default
   ;; holo-layer-python-command "python"
   holo-layer-enable-cursor-animation nil
   holo-layer-enable-window-border t
   holo-layer-active-window-color "green"
   holo-layer-inactive-window-color "gray"
   holo-layer-cursor-animation-type "jelly easing"
   holo-layer-sort-tab-ui t
   ;; holo-layer-sort-tab-font-size 30
   ;; holo-layer-cursor-animation-duration 200
   ;; holo-layer-cursor-animation-interval 10
   holo-layer-hide-mode-line t
   ;; holo-layer-cursor-color "blue"
   ;; holo-layer-cursor-alpha 220
   holo-layer-enable-debug nil
   holo-layer-enable-place-info t
   holo-layer-enable-window-number-background nil
   )
  ;; (holo-layer-enable)
  )

(use-package ctable)

;; (use-package eaf
;;   :straight (:host github :repo "manateelazycat/emacs-application-framework" :files
;; 				   ("*.el" "*.py" "*.json" "extension" "core" "app"))
;;   :config
;;   (require 'eaf-browser)
;;   (require 'eaf-pdf-viewer)
;;   (require 'eaf-pyqterminal)
;;   (require 'eaf-music-player)

;;   (eaf-setq eaf-webengine-default-zoom  "2.0"
;; 			eaf-enable-debug nil)

;;   (eaf-setq eaf-pdf-dark-mode "ignore")
;;   (setq browse-url-browser-function 'eaf-open-browser)
;;   (eaf-setq
;;    eaf-browser-auto-import-chrome-cookies t)


;;   (eaf-setq eaf-pyqterminal-font-size 32
;; 			eaf-pyqterminal-font-family "Sarasa Term SC Nerd")
;;   )


(use-package xterm-color
  :config
  (setq
   xterm-color-debug t
   xterm-color-use-bold-for-bright t
   )

  ;; (setq comint-output-filter-functions
  ;; 		(remove 'ansi-color-process-output comint-output-filter-functions))

  ;; (add-hook 'shell-mode-hook
  ;; 			(lambda ()
  ;; 			  ;; Disable font-locking in this buffer to improve performance
  ;; 			  (font-lock-mode -1)
  ;; 			  ;; Prevent font-locking from being re-enabled in this buffer
  ;; 			  (make-local-variable 'font-lock-function)
  ;; 			  (setq font-lock-function (lambda (_) nil))
  ;; 			  (add-hook 'comint-preoutput-filter-functions 'xterm-color-filter nil t)))



  )
;; (setq compilation-environment '("TERM=xterm-256color"))
;; (defun my/advice-compilation-filter (f proc string)
;;   (funcall f proc (xterm-color-filter string)))

;; (advice-add 'compilation-filter #'my/advice-compilation-filter)

;; (use-package ansi-color
;;   :config
;;   (defadvice display-message-or-buffer (before ansi-color activate)
;; 	"Process ANSI color codes in shell output."
;; 	(let ((buf (ad-get-arg 0)))
;; 	  (and (bufferp buf)
;; 		   (string= (buffer-name buf) "*Shell Command Output*")
;; 		   (with-current-buffer buf
;; 			 (ansi-color-apply-on-region (point-min) (point-max))))))

;;   (custom-set-faces '(ansi-color-black ((t ( :foreground "#696969" :background "#696969")))))
;;   (custom-set-faces '(ansi-color-white ((t ( :foreground "#d9d9d9" :background "#d9d9d9")))))
;; )


(use-package shell
  :config
  (setq
   shell-command-prompt-show-cwd t
   shell-kill-buffer-on-exit t
   )
  )

(use-package evil-numbers
  :bind (
		 ("C-c n +" . evil-numbers/inc-at-pt)
		 ("C-c n -" . evil-numbers/dec-at-pt)
		 )
  )

(use-package evil-textobj-tree-sitter)

(use-package multiple-cursors

  )
(use-package xml+
  )

(use-package iscroll
  :config
  (iscroll-mode))

;;;;;;; why? down

;; (use-package nano-theme) ;; this color theme is bad, don't use it, it will make my default color wired


(use-package subatomic256-theme)
(use-package srcery-theme)

(use-package danneskjold-theme)

(use-package creamsody-theme)
(use-package tok-theme)
(use-package darktooth-theme)
(use-package nimbus-theme)

(use-package standard-themes)
(use-package blackboard-theme)
(use-package modus-themes)

;;;;;; why? up

;; (custom-set-faces
;;  '(default (
;;             (((type tty) (min-colors 256))
;;              (:background "#282C34"))
;;             (t
;;              (:background "#282C34")))
;;     ))

(use-package popwin
  :config
  ;; (setq display-buffer-function 'popwin:display-buffer)
  ;; :global-minor-mode popwin-mode
  )
(use-package pest-mode)
(use-package popup)

(use-package spotify
  :config
  )

(use-package emms
  :init
  (emms-all)
  :config
  (setq emms-player-list '(emms-player-vlc))
  (setq emms-source-file-default-directory "~/Music")
  )
(use-package vuiet)

(use-package atomic-chrome)

(use-package kdeconnect
  :config
  (setq kdeconnect-devices "657af72589cbb5be"
		kdeconnect-active-device "657af72589cbb5be")
  )

(use-package fzf
  :bind
  ;; Don't forget to set keybinds!
  :config
  (setq fzf/args "-x --color bw --print-query --margin=1,0 --no-hscroll --layout=reverse"
		fzf/executable "fzf"
		fzf/git-grep-args "-i --line-number %s"
		;; command used for `fzf-grep-*` functions
		;; example usage for ripgrep:
		;; fzf/grep-command "rg --no-heading -nH"
		fzf/grep-command "rg --no-heading -nH"
		;; If nil, the fzf buffer will appear at the top of the window
		fzf/position-bottom t
		fzf/directory-start nil
		fzf/window-height 20))

;; (defun exec/colorize-compilation-buffer ()
;;   ;; (toggle-read-only)
;;   (ansi-color-apply-on-region compilation-filter-start (point))
;;   ;; (toggle-read-only)
;;   )

;; (add-hook 'compilation-filter-hook 'ansi-color-compilation-filter)


(use-package display-wttr
  :config
  (setq display-wttr-format "2&m"
		display-wttr-locations '("Beijing")
		display-wttr-interval (* 60 60)
		)
  )
(use-package weather-metno
  :config
  (setq weather-metno-get-image-props '(:width 16 :height 16 :ascent center))

  )

(use-package explain-pause-mode
  :config
  (setq explain-pause-top-auto-refresh-interval 1)
  )

(use-package wakatime-mode
  :config
  (setq wakatime-cli-path "/run/current-system/sw/bin/wakatime-cli")
  (global-wakatime-mode)
  )

(use-package wordreference
  :config
  (setq wordreference-source-lang "en")
  )



(use-package htmlize)
(use-package ox-reveal
  :config
  (setq org-reveal-theme "white")
  (setq org-reveal-root "https://cdn.jsdelivr.net/npm/reveal.js"
		org-reveal-plugins '(markdown zoom notes highlight)
		org-reveal-reveal-js-version 4
		org-reveal-highlight-css "%r/plugin/highlight/monokai.css"
		org-reveal-ignore-speaker-notes t
		org-reveal-extra-css "reveal.css"
		)
  )

;; closure
(use-package cider
  :config
  )


(use-package mini-frame
  :disabled t
  )


(use-package gptel
  :straight (:local-repo "~/Projects/github.com/karthink/gptel")
  :hook
  (
   (gptel-mode . (lambda()
				   (copilot-mode -1)
				   ))
   )
  :config
  (defun exec/gptel-send()
	(interactive)
	;; insert a space
	(insert " ")
	(evil-normal-state)
	(gptel-send)
	)
  (general-define-key
   :keymaps 'gptel-mode-map
   "C-<return>" 'exec/gptel-send
   "C-c C-k" 'gptel-abort
   )
  (general-define-key
   "H-m" 'gptel-menu
   )
  ;; get first line content of ~/.config/openai_api_key/key.private file to gptel-api-key, without newline
  (setq gptel-api-key
		(with-temp-buffer
		  (insert-file-contents "~/.config/openai_api_key/key.private")
		  (buffer-substring-no-properties (point-min) (line-end-position)))
		gptel-default-mode 'markdown-mode
		gptel-prompt-prefix-alist
		'((markdown-mode . "👿: ") (org-mode . "* ") (text-mode . "🤖: "))
		gptel-pre-response-hook '(lambda()
								   (interactive)
								   (recenter 0)
								   )
		gptel-post-response-hook 'end-of-buffer
		gptel-mode "gpt4"
		gptel-directives '((default .
									"You are a large language model living in Emacs and a helpful assistant. Respond concisely. Your reponse paragraph should start with `🤖:: ` please")
						   (programming .
										"You are a large language model and a careful programmer. Provide code and only code as output without any additional text, prompt or note.")
						   (writing .
									"You are a large language model and a writing assistant. Respond concisely.")
						   (chat .
								 "You are a large language model and a conversation partner. Respond concisely.")
						   (translator .
									   "You are a translator, I send you text, you translate it to Chinese")
						   )

		gptel-posframe-width 50
		gptel-posframe-height 7
		))
;;;;;;;;;;;;;;;;;;;;;;;;
;;debug and what the duck
;;
;;
(use-package chatgpt
  :straight (:host github :repo "joshcho/ChatGPT.el" :files ("dist" "*.el"))
  :init
  (require 'python)
  (setq chatgpt-repo-path "~/.emacs.d/straight/repos/ChatGPT.el/")
  :bind ("C-c q" . chatgpt-query))

(defun exec/vterm-post-hook()
  (interactive)
  (setq-local buffer-face-mode-face '(:family "Sarasa Term SC"))
  ;; (setq-local  buffer-face-mode-face '(
  ;; 									   ;; "NotoSansMNerdFontMono"
  ;; 									   :family "JetBrainsMonoNL Nerd Font"
  ;; 									   ;; :height  100
  ;; 									   :background "black"
  ;; 									   )
  ;; 			   )
  ;; (setq-local mode-line-format nil)
  ;; (tab-line-mode -1)
  (buffer-face-mode)
  ;; (origami-mode -1)
  ;; (fringe-mode -1)
  ;; (set-left-margin 0)
  ;; (set-right-margin 0)
  )

(use-package vterm
  ;; :bind ("C-<return>" . vterm-send-return)
  :hook (vterm-mode  . exec/vterm-post-hook)
  :custom
  (shell-file-name "zsh")
  :config
  (general-evil-define-key 'insert 'vterm-mode-map
	"C-r" 'vterm--self-insert

	"C-p" 'vterm--self-insert
	"C-n" 'vterm--self-insert

	"C-a" 'vterm--self-insert
	"C-e" 'vterm--self-insert

	"C-w" 'vterm--self-insert

	"C-d" 'vterm--self-insert
	"C-c" 'vterm--self-insert

	"C-e" 'vterm--self-insert
	"C-h" 'vterm--self-insert
	"C-l" 'vterm--self-insert
	"<escape>" 'vterm--self-insert
	)

  (setq-default vterm-always-compile-module t
				vterm-set-bold-hightbright t
				)
  (set-face-attribute 'vterm-color-blue nil :foreground "#268bd2" :background "#268bd2")
  (set-face-attribute 'vterm-color-black nil :foreground "gray"    :background "dim gray")
  )

(use-package eat
  :disabled
  :straight (:type git :host codeberg :repo "akib/emacs-eat"
				   :files ("*.el" ("term" "term/*.el") "*.texi"
						   "*.ti" ("terminfo/e" "terminfo/e/*")
						   ("terminfo/65" "terminfo/65/*")
						   ("integration" "integration/*")
						   (:exclude ".dir-locals.el" "*-tests.el"))
				   )
  :config
  (add-hook 'eshell-load-hook #'eat-eshell-mode))

(use-package fcitx
  :disabled
  :after evil
  :config
  (setq fcitx-remote-command "fcitx5-remote")
  (fcitx-prefix-keys-turn-off)
  (fcitx-default-setup))


(use-package rime
  :disabled
  :straight (:type built-in)
  :init
  (setq rime-show-candidate 'posframe
		default-input-method "rime"
		)
  (setq rime-user-data-dir "~/.local/share/fcitx5/rime")
  :bind ("s-=" . 'toggle-input-method)
  :config
  ;; (setq rime-posframe-properties
  ;; 		(list :font "Noto Sans CJK SC"
  ;; 			  :internal-border-width 1))
  (setq rime-show-preedit t)
  )

(unless (server-running-p)
  (server-start))
;;; init.el ends here




(use-package zoom
  :custom
  (zoom-size  '(0.618 . 0.618))
  ;; :global-minor-mode zoom-mode
  )

(use-package echo-bar
  :config
  ;; (echo-bar-mode)
  )

(use-package google-this)

(use-package imenu
  :straight (:type built-in)
  :config
  (setopt imenu-max-item-length nil
		  imenu-space-replacement nil)
  )

(use-package imenu-list
  :ensure nil
  :straight (imenu-list :type git :host github :repo "bmag/imenu-list")
  :custom-face
  (imenu-list-entry-subalist-face-0 ((t (:underline nil))))
  ;; :hook
  ;; (prog-mode . imenu-list-minor-mode)
  :config
  (setopt imenu-list-auto-resize nil
		  imenu-list-size (/ (float (if (boundp 'treemacs-width) treemacs-width 33))  (frame-width)))

  (defun exec/imenu-list-set-window-parameters()
	(interactive)
	(window-preserve-size (get-buffer-window imenu-list-buffer-name) t t)
	(set-window-parameter
	 (get-buffer-window imenu-list-buffer-name)
	 'no-other-window t)
	;; (set-window-parameter
	;;  (get-buffer-window imenu-list-buffer-name)
	;;  'window-side 'right)
	;; (set-window-parameter
	;;  (get-buffer-window imenu-list-buffer-name)
	;;  'window-slot 0)
	(set-window-parameter
	 (get-buffer-window imenu-list-buffer-name)
	 'no-delete-other-windows t)
	)

  (add-hook 'imenu-list-minor-mode-hook 'exec/imenu-list-set-window-parameters)

  (add-hook 'imenu-list-update-hook
			'(lambda()
			   (if (= (length imenu-list--imenu-entries) 0)
				   (imenu-list-quit-window))))

  ;; (defun imenu-list-display-buffer (buffer alist)
  ;;   "Display the imenu-list buffer at the side.
  ;; This function should be used with `display-buffer-alist'.
  ;; See `display-buffer-alist' for a description of BUFFER and ALIST."
  ;;   (or (get-buffer-window buffer)

  ;;       (let ((window (ignore-errors (split-window (frame-root-window) (imenu-list-split-size) imenu-list-position))))
  ;;         (when window
  ;;           ;; since Emacs 27.0.50, `window--display-buffer' doesn't take a
  ;;           ;; `dedicated' argument, so instead call `set-window-dedicated-p'
  ;;           ;; directly (works both on new and old Emacs versions)
  ;;           (window--display-buffer buffer window 'window alist)
  ;;           (set-window-dedicated-p window t)
  ;;           window))
  ;; 	  ))


  (require 's)
  (defun exec/imenu-get-icon(entry &optional name)
	(cond ((equal entry "Types") (nerd-icons-codicon "nf-cod-symbol_class"))
		  ((equal entry "Type") (nerd-icons-codicon "nf-cod-symbol_class"))
		  ((equal entry "Variables") (nerd-icons-codicon "nf-cod-symbol_variable"))
		  ((equal entry "Struct") (nerd-icons-codicon "nf-cod-symbol_structure"))
		  ((equal entry "Interface") (nerd-icons-codicon "nf-cod-symbol_interface"))
		  ((equal entry "Function") (nerd-icons-mdicon "nf-md-function"))
		  ((equal entry "Method") (nerd-icons-codicon "nf-cod-symbol_method"))
		  ((equal entry "Package") (nerd-icons-codicon "nf-cod-package"))
		  ((equal entry "Packages") (nerd-icons-codicon "nf-cod-package"))
		  ((equal entry "Fn") (nerd-icons-mdicon "nf-md-function"))

		  ((s-contains? "fn(" (format "%s" entry)) (nerd-icons-mdicon "nf-md-function"))
		  ((equal entry nil)
		   (cond
			((s-suffix? "-mode-map" (format "%s" name)) (nerd-icons-mdicon "nf-md-map"))
			((s-prefix? "exec/" (format "%s" name)) "👿")
			((s-contains? " fn(" name) (nerd-icons-mdicon "nf-md-function"))
			((equal name "Signature") (nerd-icons-mdicon "nf-md-signature_freehand"))
			((equal name "References") (nerd-icons-codicon "nf-cod-references"))
			((equal name "Documentation") (nerd-icons-mdicon "nf-md-file_document"))
			((equal name "Debugging") (nerd-icons-codicon "nf-cod-debug"))
			((equal name "Source Code") (nerd-icons-codicon "nf-cod-code"))
			(t
			 (nerd-icons-mdicon "nf-md-null")
			 ;; ""
			 )))
		  (t (progn
			   (nerd-icons-codicon "nf-cod-question")
			   ;; ""
			   ))))

  (defun imenu-list-insert-entries ()
	"Insert all imenu entries into the current buffer.
The entries are taken from `imenu-list--imenu-entries'.
Each entry is inserted in its own line.
Each entry is appended to `imenu-list--line-entries' as well
 (`imenu-list--line-entries' is cleared in the beginning of this
function)."
	(let ((inhibit-read-only t))
	  (erase-buffer)
	  (setq imenu-list--line-entries nil)
	  (imenu-list--insert-entries-internal nil imenu-list--imenu-entries 0)
	  (setq imenu-list--line-entries (nreverse imenu-list--line-entries))))

  (defun imenu-list--insert-entries-internal (parent_entry index-alist depth)
	"Insert all imenu entries in INDEX-ALIST into the current buffer.
DEPTH is the depth of the code block were the entries are written.
Each entry is inserted in its own line.
Each entry is appended to `imenu-list--line-entries' as well."
	(dolist (entry index-alist)
	  (setq imenu-list--line-entries (cons entry imenu-list--line-entries))
	  (imenu-list--insert-entry parent_entry entry depth)
	  (when (imenu--subalist-p entry)
		(imenu-list--insert-entries-internal (car entry) (cdr entry) (1+ depth)))))

  (defun imenu-list--insert-entry (parent-entry entry depth)
	"Insert a line for ENTRY with DEPTH."
	(if (imenu--subalist-p entry)
		(progn
		  (insert (imenu-list--depth-string depth))
		  (insert-button (format "%s %s"
								 (if
									 (not parent-entry)
									 (exec/imenu-get-icon (car entry))
								   (exec/imenu-get-icon parent-entry))
								 (car entry))
						 'face (imenu-list--get-face depth t)
						 'help-echo (format "Toggle: %s"
											(car entry))
						 'follow-link t
						 'action ;; #'imenu-list--action-goto-entry
						 #'imenu-list--action-toggle-hs)
		  (insert "\n"))
	  (insert (imenu-list--depth-string depth))
	  (insert-button (format "%s %s"
							 (exec/imenu-get-icon parent-entry (car entry))
							 (car entry))
					 'face (imenu-list--get-face depth nil)
					 'help-echo (format "Go to: %s"
										(car entry))
					 'follow-link t
					 'action #'imenu-list--action-goto-entry)
	  (insert "\n"))))



(use-package hl-line
  :hook
  (after-init . global-hl-line-mode)
  :custom-face
  (hl-line ((t (:background "gray20" :inherit nil))))
  )

(use-package hl-line+
  :hook
  (window-scroll-functions . hl-line-flash)
  ;; (focus-in . hl-line-flash)
  ;; (post-command . hl-line-flash)

  :custom
  (global-hl-line-mode nil)
  (hl-line-flash-show-period 0.5)
  (hl-line-inhibit-highlighting-for-modes '(dired-mode))
  (hl-line-overlay-priority -100) ;; sadly, seems not observed by diredfl
  )

(use-package form-feed-st
  :config
  (global-form-feed-st-mode)
  )

(put 'list-timers 'disabled nil)


;; (use-package crazy-theme
;;   :straight (:local-repo "~/Projects/github.com/eval-exec/crazy-theme.el")
;;   :config
;;   )

;; execute `xdotool getactivewindow', assert we will get an interger number, and write this file into /tmp/show_hide/emacs.wid
(defun exec/get-active-window-id ()
  (let ((window-id (shell-command-to-string "xdotool getactivewindow")))
    (string-to-number window-id)))

(defun exec/write-window-id-to-file (file-path window-id)
  (with-temp-file file-path
    (insert (number-to-string window-id))))

(defun exec/write-window-id()
  (interactive)
  (setq window-id (exec/get-active-window-id))
  (let ((file-path "/tmp/_-_GNU_Emacs_at_Mufasa.wid"))
	(exec/write-window-id-to-file file-path window-id))
  (remove-hook 'focus-in-hook 'exec/write-window-id)
  )

(add-hook 'focus-in-hook 'exec/write-window-id)



(defun exec/keymap-symbol (keymap)
  "Return the symbol to which KEYMAP is bound, or nil if no such symbol exists."
  (interactive)
  (catch 'gotit
    (mapatoms (lambda (sym)
                (and (boundp sym)
                     (eq (symbol-value sym) keymap)
                     (not (eq sym 'keymap))
                     (throw 'gotit sym))))))

(defun exec/print-keymap-symbol()
  (interactive)
  (message (exec/keymap-symbol (current-local-map))))

(general-def
  "H-i" 'exec/print-keymap-symbol
  "<mouse-8>" 'evil-jump-backward
  "<mouse-9>" 'evil-jump-forward
  )

(defun exec/minibuffer-setup ()
  (set (make-local-variable 'face-remapping-alist)
	   '((default :height 0.8))))
;; (add-hook 'minibuffer-setup-hook 'exec/minibuffer-setup)



(use-package tabspaces
  :disabled
  :hook (after-init . tabspaces-mode) ;; use this only if you want the minor-mode loaded at startup.
  :commands (tabspaces-switch-or-create-workspace
             tabspaces-open-or-create-project-and-workspace)
  :custom
  (tabspaces-use-filtered-buffers-as-default t)
  (tabspaces-default-tab "Default")
  (tabspaces-remove-to-default t)
  (tabspaces-include-buffers '("*scratch*"))
  (tabspaces-initialize-project-with-todo t)
  (tabspaces-todo-file-name "project-todo.org")
  ;; sessions
  (tabspaces-session t)
  (tabspaces-session-auto-restore t))

(use-package persp-mode
  :disabled
  :custom
  (persp-keymap-prefix (kbd "<f5>"))
  :config
  (persp-mode t)

  (use-package persp-mode-projectile-bridge
	:config

	(add-hook 'persp-mode-projectile-bridge-mode-hook #'(lambda ()
														  (if persp-mode-projectile-bridge-mode
															  (persp-mode-projectile-bridge-find-perspectives-for-all-buffers)
															(persp-mode-projectile-bridge-kill-perspectives))))
	(add-hook 'after-init-hook #'(lambda ()
								   (persp-mode-projectile-bridge-mode 1))
			  t)))

(defun exec/self-screenshot (&optional type)
  "Save a screenshot of type TYPE of the current Emacs frame.
As shown by the function `', type can weild the value `svg',
`png', `pdf'.

This function will output in /tmp a file beginning with \"Emacs\"
and ending with the extension of the requested TYPE."
  (interactive (list
                (intern (completing-read "Screenshot type: "
                                         '(png svg pdf postscript)))))
  (let* ((extension (pcase type
                      ('png        ".png")
                      ('svg        ".svg")
                      ('pdf        ".pdf")
                      ('postscript ".ps")
                      (otherwise (error "Cannot export screenshot of type %s" otherwise))))
         (filename (make-temp-file "Emacs-" nil extension))
         (data     (x-export-frames nil type)))
    (with-temp-file filename
      (insert data))
    (kill-new filename)
    (message filename)))


(use-package prism)

(use-package bufler
  :disabled
  :config
  (bufler-mode)
  (bufler-workspace-mode)
  )
(use-package burly)

(use-package timer
  :straight (:type built-in)
  :config
  (general-nmap 'timer-list-mode-map
	"c" 'timer-list-cancel))

(progn ;; Life
  (defun exec/washing-machine-alert()
	(notifications-notify
	 :title "洗衣机检查提醒"
	 :body "！洗衣机于现在应该洗好了"))

  ;; (run-at-time "11:30" 10 #'exec/washing-machine-alert)
  )

(setq debug-on-error nil)
