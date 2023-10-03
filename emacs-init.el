;;; package --- Summary -*- lexical-binding: t -*-
;;; Code:


(setq debug-on-error t)
(setq debug-on-signal nil)





(setq url-proxy-services '(("no_proxy" . "^\\(localhost\\|10\\..*\\|192\\.168\\..*\\)")
						   ("http" . "127.0.0.1:7890")
						   ("https" . "127.0.0.1:7890")))






(setq straight-repository-branch "develop")


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

  (setq switch-to-buffer-obey-display-actions t)
  (setq auto-save-default nil)
  (setq next-line-add-newlines t)
  (setq mouse-wheel-flip-direction t
		mouse-wheel-tilt-scroll t
		)
  (setq font-lock-maximum-decoration
		1
		;; '(
		;; 							   (markdown-mode . nil)
		;; 							   (t . 2)
		;; 							   )
		)
 ;; (setq display-buffer-base-action '(nil . ((inhibit-same-window . t))))

  (setq mode-line-compact t
		mode-line-in-non-selected-windows t
		mode-line-percent-position nil
		mode-line-position-column-line-format '("[📝%l,%c]")
		)
  (setq-default mode-line-format 
		'("%e"
		  mode-line-front-space
		  (:propertize
		   ("" mode-line-mule-info mode-line-client mode-line-modified
			mode-line-remote)
		   display (min-width (5.0)))
		  mode-line-frame-identification
		  mode-line-buffer-identification
		  "   "
		  mode-line-position
		  evil-mode-line-tag
		  (vc-mode vc-mode)
		  "  "
		  ;; mode-line-modes
		  mode-line-misc-info
		  mode-line-end-spaces))

  (set-face-attribute 'mode-line nil)
  (set-face-attribute 'mode-line-active nil :background "#8b0000" :foreground "white")
  (set-face-attribute 'mode-line-inactive nil)

  (setq vc-follow-symlinks t)
  (setq custom-safe-themes t)
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
  (setq max-lisp-eval-depth 1600)

  (setq frame-title-format "Eval EXEC - GNU Emacs at Mufasa")
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
  (setq window-resize-pixelwise t)
  (setq frame-resize-pixelwise t)
  (setq column-number-mode t)
  (setq line-number-mode t)
  (setq mode-line-percent-position '(-3 "%o"))

  ;; (add-to-list 'default-frame-alist '(foreground-color . "white"))
  ;; (add-to-list 'default-frame-alist '(background-color . "black"))
  (set-cursor-color "yellow")


;; 🧬 
;; it’s 中文测试`''`'《》，。
  ;;- [X] sub task two
  ;;- [ ] sub task three
  (setq use-default-font-for-symbols nil)
  (set-fontset-font t 'unicode "JuliaMono")
  (set-fontset-font t 'ascii "Noto Sans" nil 'prepend)
  (set-fontset-font t 'han "Sarasa Gothic SC")
  (set-fontset-font t 'cjk-misc "Sarasa Gothic SC")
  (set-fontset-font t 'emoji "Noto Color Emoji")
  (set-fontset-font t 'symbol "Symbola")
  (set-fontset-font t 'symbol "JuliaMono" nil 'prepend)


  (setq revert-without-query '(".*"))




  :hook
  (
   ;; (after-init . savehist-mode)
   ;; (after-init . size-indication-mode)
   (after-init . global-auto-revert-mode)
   )
  :config
  (setq split-height-threshold 60
		split-width-threshold 180
		split-window-preferred-function 'exec/split-window-really-sensibly
		)

  )

(defun exec/increase-buffer-font()
  (interactive)
  ;; (setq-local buffer-face-mode-face '(:height 100))
  ;; (buffer-face-mode)
  )
(defun exec/decrease-buffer-font()
  (interactive)
  (setq-local buffer-face-mode-face '(:height 0.8))
  (buffer-face-mode)
  )

(defun exec/prog-mode-fixed()
  "Set a fixed width (monospace) font in current buffer."
  (interactive)
  (setq-local buffer-face-mode-face '(:family "Unifont"))
  ;; (buffer-face-mode)
  )

(defun exec/sans-mode()
  (interactive)
  ;; (setq-local buffer-face-mode-face '(:family "Noto Sans"))
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
  :init
  (setq 
    evil-want-keybinding nil
    evil-want-integration t
    evil-respect-visual-line-mode t
    evil-v$-excludes-newline t
    )
  :demand t
  :config
  (evil-mode t)
  (general-evil-setup)

  (setopt evil-disable-insert-state-bindings nil
		  evil-search-module 'evil-search
		  evil-symbol-word-search t
		  evil-move-beyond-eol nil)

  ;; (defalias #'forward-evil-word #'forward-evil-symbol)

  (setq evil-want-minibuffer t)
  (setq evil-want-C-i-jump t)
  (setq evil-jumps-cross-buffers t)
  (setq evil-search-wrap-ring-bell t) ;;
  (setq evil-want-C-u-scroll t)
  (setq evil-want-fine-undo t)

  (evil-set-undo-system  'undo-redo)
  

  (setq evil-ex-search-highlight-all nil)
  (setq undo-tree-auto-save-history nil)

  ;; (evil-define-key 'normal org-mode-map (kbd "<tab>") #'org-cycle)
  ;; (evil-define-key 'normal org-mode-map (kbd "RET") #'org-return)
  (with-eval-after-load 'evil-maps
	;; (define-key evil-motion-state-map (kbd "SPC") nil)
	(define-key evil-motion-state-map (kbd "RET") nil)
	(define-key evil-motion-state-map (kbd "TAB") nil)
	)
  
  

  (general-define-key [remap evil-quit] 'kill-buffer-and-window)

  (evil-add-command-properties #'find-file-at-point :jump t)
  (evil-add-command-properties #'consult-line :jump t)
  (evil-add-command-properties #'org-agenda-switch-to :jump t)

  (setq evil-normal-state-tag   (propertize "<N>" 'face '((:background "#013220"   :foreground "white")))
		evil-emacs-state-tag    (propertize "<E>" 'face '((:background "Yellow"    :foreground "black")))
		evil-insert-state-tag   (propertize "<I>" 'face '((:background "Red"       :foreground "yellow")))
		evil-replace-state-tag  (propertize "<R>" 'face '((:background "chocolate" :foreground "black")))
		evil-motion-state-tag   (propertize "<M>" 'face '((:background "plum3"     :foreground "black")))
		evil-visual-state-tag   (propertize "<V>" 'face '((:background "Purple"    :foreground "white")))
		evil-operator-state-tag (propertize "<O>" 'face '((:background "Blue"      :foreground "white"))))

  ;; (setq evil-normal-state-tag   (propertize "N" 'face nil)
  ;; 		evil-emacs-state-tag    (propertize "E" 'face nil)
  ;; 		evil-insert-state-tag   (propertize "I" 'face nil)
  ;; 		evil-replace-state-tag  (propertize "R" 'face nil)
  ;; 		evil-motion-state-tag   (propertize "M" 'face nil)
  ;; 		evil-visual-state-tag   (propertize "V" 'face nil)
  ;; 		evil-operator-state-tag (propertize "O" 'face nil))

  )

(use-package evil-collection
  :after evil
  :custom
  (evil-collection-setup-minibuffer t)
  (evil-collection-want-find-usages-bindings t)
  :init
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
(setq scroll-conservatively 101
	  scroll-margin 0
	  scroll-step 0
	  scroll-preserve-screen-position nil
	  scroll-up-aggressively 0
	  scroll-down-aggressively 0
	  fast-but-imprecise-scrolling t
	  )

(setq make-pointer-invisible nil)
(setq mouse-highlight t)
(setq-default tab-width 4)

(setq blink-cursor-blinks -1
	  blink-cursor-delay 0
	  blink-cursor-interval 0.2)
(blink-cursor-mode t)

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

(setq display-line-numbers-type 'visual
	  display-line-numbers-grow-only t
	  display-line-numbers-width 4
	  display-line-numbers-widen t
	  )




;; (setq window-resize-pixelwise nil)
;; (setq frame-resize-pixelwise nil)
(setq-default tab-width 4)
(setq-default c-basic-offset 4)

(setq word-wrap t)
(global-visual-line-mode t)
(fringe-mode 0)
(setf left-margin 16)

(setq visual-line-fringe-indicators '(left-curly-arrow right-curly-arrow))


(setq display-line-numbers-width-start t)
(setq native-comp-async-report-warnings-errors nil)
(setq imenu-auto-rescan t)


(setq make-backup-files nil)
(setq create-lockfiles nil)


(setq org-roam-v2-ack t)

(setq inhibit-compacting-font-caches t)

(setq require-final-newline t)
(setq load-prefer-newer t)


(set-default-coding-systems 'utf-8)

(setenv "PKG_CONFIG_PATH" "/nix/store/80rbkkz1jh3ybsc5r4dz2bmn02vljn1c-openssl-3.0.8-dev/lib/pkgconfig")
(setenv "LD_LIBRARY_PATH" "/run/current-system/sw/share/nix-ld/lib")

(setenv "LANG" "en_US.UTF-8")
(setenv "LC_ALL" "en_US.UTF-8")
;; (setenv "LC_CTYPE" "zh_CN.UTF-8")
(setenv "GOARCH" "amd64")
(setenv "TERM" "xterm-256color")
(setenv "GTK_IM_MODULE" "fcitx")
(setenv "INPUT_METHOD" "fcitx")
(setenv "QT_IM_MODULE" "fcitx")
(setenv "SDL_IM_MODULE" "fcitx")
(setenv "XMODIFIERS" "@im=fcitx")
(setenv "PATH" "/nix/store/k2j9x9kzss7jhqvwsaas9ikyiq8031q5-xwininfo-1.1.6/bin:/nix/store/ycvfy4cg0ky81gp0566dpdl6apxjzrjx-xdotool-3.20211022.1/bin:/nix/store/5fa4i3i5dgqk49lxbz952jnph01im948-xprop-1.2.6/bin:/nix/store/3mpa96b8hi3gfx17099xwgfnp6kbz4ga-gawk-5.2.2/bin:/nix/store/8fdd0nqajq5sk1m6p4qnn0z0j9d7n3q5-coreutils-9.3/bin:/nix/store/2hz0i9y0xck9y4pq1rabi0cwk4kylgrw-gnugrep-3.11/bin:/nix/store/sxk30xba5nyvw8p10pfpgq5p9skhhi0a-procps-3.3.17/bin:/home/exec/.cargo/bin:/home/exec/.local/bin:/run/wrappers/bin:/home/exec/.nix-profile/bin:/etc/profiles/per-user/exec/bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin:/home/exec/.oh-my-zsh/custom/plugins/warhol/bin:/home/exec/.oh-my-zsh/custom/plugins/warhol/bin")

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
  (unless (exec/imenu-goto--closest-dir 1)
    (goto-char (point-max))))

(defun exec/imenu-goto-prev ()
  (interactive)
  (unless (exec/imenu-goto--closest-dir -1)
    (goto-char (point-min))))



(general-define-key
 :states '(normal visual)
 :keymaps 'override
 "M-j" 'exec/imenu-goto-next
 "M-k" 'exec/imenu-goto-prev
 )


(general-def 'normal "gd" 'xref-find-definitions)
(general-def 'normal "gr" 'xref-find-references)
(general-def 'insert "C-SPC" 'completion-at-point)

(general-define-key :state
					'normal "C-S-c" 'exec/put-file-name-on-clipboard)


(general-evil-define-key '(normal visual) 'global
  "gr" 'xref-find-references
  "gd" 'xref-find-definitions
  "ga" 'xref-find-apropos
  )


;; (with-eval-after-load 'evil-mode
;; )

(defun exec/consult-imenu-or-outline()
  "First run `consult-imenu'.
if it encounter an error, then we execute `consult-outline'."
  (interactive)
  (condition-case nil
	  (consult-imenu)
	(error (consult-outline))))

(global-definer
  "i" 'exec/consult-imenu-or-outline
  "!"   'shell-command
  ":"   'eval-expression)

(+general-global-menu! "buffer" "b"
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
  ;; "f" '(lambda()
  ;; 		 (interactive)
  ;; 		 (rg-define-search exec/search-init
  ;; 				  :query ask
  ;; 				  :format literal
  ;; 				  :files "init.el"
  ;; 				  :dir user-emacs-directory
  ;; 				  )
  ;; 		 ;; interactive call exec/search-init
  ;; 		 (call-interactively 'exec/search-init)
  ;; 		 )
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

(general-def )

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

(general-define-key
 :prefix "C-c"
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
(general-def
  :prefix "H-h"
  "k" 'helpful-key
  "v" 'helpful-variable
  "o" 'helpful-symbol
  "P" 'helpful-at-point
  "f" 'helpful-function
  "m" 'helpful-macro
  "c" 'helpful-command
  "C" 'helpful-callable
  )

(general-def
  "H-SPC" 'which-key-show-major-mode
  "H-M-SPC" 'exec/which-key-show-top-level
  "C-H-SPC" 'which-key-show-minor-mode-keymap

  "H-z" 'repeat
  )


(general-def
  "H-h" 'help-command
  "H-k" 'kill-current-buffer
  "H-<left>" 'winner-undo
  "H-<right>" 'winner-redo

  "C-H-<left>" 'tab-line-switch-to-prev-tab
  "C-H-<right>" 'tab-line-switch-to-next-tab
  "H-`" 'garbage-collect
  ;; "H-i" 'yas-insert-snippet
  "H-a" 'org-agenda
  )


(general-evil-define-key 'insert 'global
  "<escape>" '(lambda()
				(interactive)
				(if (bound-and-true-p corfu-mode)
					(corfu-quit))
				(if (bound-and-true-p copilot-mode)
					(copilot-clear-overlay))
				(evil-normal-state)
				)
  "C-h" 'left-char
  "C-l" 'right-char
  "C-j" 'next-line
  "C-k" 'previous-line
  )

(general-evil-define-key 'insert copilot-mode-map
  "<tab>" '(lambda()
			 (interactive)
			 (if (copilot--overlay-visible)
				 (copilot-accept-completion)
			   (tab-to-tab-stop))
			 )
  "C-/" 'copilot-next-completion
  "C-f" 'copilot-accept-completion-by-line
  "M-f" 'copilot-accept-completion-by-word
  "C-<escape>" 'copilot-clear-overlay
  )


(general-define-key
 :keymaps 'projectile-command-map
 "f" 'consult-projectile-find-file
 "b" 'consult-projectile-switch-to-buffer
 )

(general-define-key
 :keymaps 'origami-mode-map
 "<tab>" 'origami-recursively-toggle-node
 "<backtab>" 'origami-toggle-all-nodes
 )

(general-define-key
 :keymaps 'diff-hl-mode-map
 "C-M-z" 'diff-hl-revert-hunk
 )

(general-define-key
 :keymaps 'flycheck-mode-map
 "M-g n" 'flycheck-next-error
 )

(general-evil-define-key 'normal 'global
  "M-f" 'consult-line
  )


(defun exec/open-config()
  "Open config file."
  (interactive)
  ;; if "init.el" buffer has already opened in current frame, then focus to that window
  (if (equal (buffer-name) "emacs-init.el")
	  (switch-to-buffer (other-buffer))
	;; open user-init-file buffer of open this file
	;; (if (get-buffer "init.el")
	;; 	(switch-to-buffer "init.el")
	(if (get-buffer-window "init.el")
		(select-window (get-buffer-window "emacs-init.el"))
	  (find-file "~/Projects/github.com/eval-exec/nixos-config/emacs-init.el"))
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

;; define C-x f to consult-recent-file
(general-define-key
 "C-x C-r" 'consult-recent-file
 "C-x C-f" 'find-file
 "C-S-f" 'deadgrep
 "H-f" '(lambda()
		  (interactive)
		  ;; if vterm-buffer-name variable is not set, eval (vterm) and return
		  (if (not (bound-and-true-p vterm-buffer-name))
			  (vterm)
			(if 
				(equal (buffer-name) vterm-buffer-name)
				(switch-to-buffer (other-buffer))
			  (vterm)))
		  )

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
  )

(general-define-key
  "M-0" 
 'dired-sidebar-show-sidebar
 )



(setq debug-on-error nil)



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
(add-to-list 'display-buffer-alist
			 '(
			   "\\*Help\\* *"
			   (display-buffer-in-side-window)
			   (side . bottom)
			   (slot . 2)
			   ))

(add-to-list 'display-buffer-alist
			 '(
			   "\\*Outline *pdf\\*"
			   (display-buffer-in-side-window)
			   (side . right)
			   (slot . 1)
			   ))

(add-to-list 'display-buffer-alist
			 '(
			   "\\*Flycheck errors\\* *"
			   (display-buffer-in-side-window)
			   (side . bottom)
			   (slot . 0)
			   (window-height . 0.3)
			   )
			 )

(add-to-list 'display-buffer-alist
			 '(
			   "\\*Warnings\\* *"
			   (display-buffer-in-side-window)
			   (side . bottom)
			   (slot . 0)
			   (window-height . 0.3)
			   )
			 )

(add-to-list 'display-buffer-alist
			 '(
			   "\\*Process List\\*"
			   (display-buffer-in-side-window)
			   (side . bottom)
			   (slot . 0)
			   (window-height . 0.2)
			   )
			 )

(add-to-list 'display-buffer-alist
			 '(
			   "\\*Messages\\*"
			   (display-buffer-in-side-window)
			   (side . bottom)
			   (slot . 0)
			   (window-height . 0.2)
			   )
			 )
(add-to-list 'display-buffer-alist
			 '(
			   "\\*color-rg\\*"
			   (display-buffer-in-side-window)
			   (side . bottom)
			   (slot . 0)
			   (window-height . 0.25)
			   )
			 )


(add-to-list 'display-buffer-alist
			 '(
			   "\\*Ilist\\*"
			   (display-buffer-in-side-window)
			   (side . left)
			   (slot . 2)
			   (window-height . 0.3)
			   )
			 )

(add-to-list 'display-buffer-alist
			 '("\\*org-roam\\*"
			   (display-buffer-in-side-window)
			   (side . right)
			   (slot . 1)
			   (window-parameters . ((no-other-window . t)
									 (no-delete-other-windows . t)))))

(add-to-list 'display-buffer-alist
			 '(
			   "\\*Go-Translate\\*"
			   (display-buffer-in-side-window)
			   (side . bottom)
			   (slot . 4)
			   (window-height . 0.5)
			   )
			 )



; (load "/home/exec/Projects/github.com/eval-exec/crazy-theme.el/crazy-theme.el")
; (setq crazy-theme-prefer-dark nil)
; (load-theme 'crazy)


(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(line-number ((t (:family "Noto Sans Mono"
							:width ultra-condensed
							:foreground "grey"))))

 '(line-number-current-line ((t (:background "#880000"
											 :foreground "#ffffff"
											 :width ultra-condensed
											 :weight extra-bold
											 :family "Noto Sans Mono"))))
 '(mode-line ((t (:box nil))))

 '(imenu-list-entry-face ((t (:height 0.8))))
 )


(defun exec/mode-line-insert-hook()
  (interactive)
  (set-face-attribute 'mode-line-active nil :background "#8b0000" :foreground "white" :inherit nil)
  ;; (set-face-attribute 'line-number-current-line nil :background "#8b0000" :foreground "white")
  )
(defun exec/mode-line-normal-hook()
  (interactive)
  (set-face-attribute 'mode-line-active nil :background "#013220" :foreground "white" :inherit nil)
  ;; (set-face-attribute 'line-number-current-line nil :background "#013220" :foreground "white")
  )
(defun exec/mode-line-visual-hook()
  (interactive)
  ;; (set-face-attribute 'mode-line-active nil :background "orange" :foreground "white" :inherit nil)
  ;; (set-face-attribute 'line-number-current-line nil :background "purple" :foreground "white")
  )

(defun exec/mode-line-emacs-hook()
  (interactive)
  (set-face-attribute 'mode-line-active nil :background "purple" :foreground "white" :inherit nil)
  )

;; (add-hook 'evil-insert-state-entry-hook 'exec/mode-line-insert-hook)
(add-hook 'evil-normal-state-entry-hook 'exec/mode-line-normal-hook)
;; (add-hook 'evil-visual-state-entry-hook 'exec/mode-line-visual-hook)
(add-hook 'evil-emacs-state-entry-hook 'exec/mode-line-emacs-hook)
(add-hook 'evil-emacs-state-exit-hook 'exec/mode-line-normal-hook)


(defun disable-all-themes ()
  "Disable all active themes."
  (dolist (i custom-enabled-themes)
	(disable-theme i))
  )

(defadvice load-theme (before disable-themes-first activate)
  (disable-all-themes))


(add-hook 'after-init-hook '(lambda()
							  (load-theme
							   ;; 'nasy
							   ;; 'doom-vibrant
							   ;; 'atom-one-dark
							   ;; 'professional
							   ;; 'modus-vivendi
							   ;; 'almost-mono-black
							   'sanityinc-tomorrow-bright
							   )

							  (org-agenda-list) ;; consider set initial-buffer-choice to "*Org Agenda*" buffer
							  ))



(use-package vertico
  :demand t
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
   vertico-count 20
   vertico-resize t
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
  ;; (vertico-buffer-mode)
  )


(use-package vertico-posframe
  :config
  (setq vertico-posframe-parameters '((left-fringe . 0)
									  (right-fringe . 0)
									  )
		vertico-posframe-border-width 0
		vertico-posframe-poshandler
		;; 'posframe-poshandler-window-bottom-center
		'posframe-poshandler-frame-bottom-center
		;; 'posframe-poshandler-frame-top-right-corner
		vertico-posframe-width 200
		vertico-posframe-font nil
		;; "Noto Sans Mono"
		vertico-posframe-min-height nil
		vertico-flat-max-lines 3
		)

  ;; (custom-set-faces
  ;;  '(vertico-posframe-border
  ;; 	 ((t (:inherit default :background "pink"))))
  ;;  )

  (vertico-posframe-mode)
  )

;;;; ============================================================


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


(use-package gcmh
  :hook (
		 (emacs-startup . gcmh-mode)
		 (focus-out . garbage-collect)
		 )
  :config
  (setq
   gc-cons-percentage 1.0
   garbage-collection-messages nil
   gcmh-verbose nil
   gcmh-idle-delay 'auto
   gcmh-high-cons-threshold (* 32 1024 1024)
   )
  )


(setq native-comp-always-compile t)
(setq native-comp-async-jobs-number  12)
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

(use-package man
  :config
  (setq Man-width nil)
  (setq Man-width-max nil)
  (setq Man-notify-method 'pushy)
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
		  "https://planet.emacslife.com/atom.xml"))
  (use-package elfeed-dashboard)
  )

(add-hook 'prog-mode-hook 'electric-pair-local-mode)
(add-hook 'minibuffer-mode-hook 'electric-pair-local-mode)
(add-hook 'prog-mode-hook 'electric-indent-mode)
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

  :config
  (setq flycheck-display-errors-delay 0
		flycheck-idle-change-delay 0.2
		flycheck-checker-error-threshold 800
		)
  (setq flycheck-rust-executable "cargo-clippy")

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
  )

(use-package flycheck-posframe
  :hook
  (flycheck-mode . flycheck-posframe-mode)
  :custom-face
  (flycheck-posframe-face ((t (:height 1.0))))
  :config
  (setq
   flycheck-posframe-position 'window-top-right-corner
   flycheck-posframe-border-use-error-face t
   flycheck-posframe-border-width 1
   flycheck-posframe-info-prefix "💬 "
   flycheck-posframe-warning-prefix "⚠️ "
   flycheck-posframe-error-prefix "❌ "
   )
  )

(use-package flycheck-status-emoji
  :config
  (flycheck-status-emoji-mode))

(use-package flycheck-aspell
  :after (flycheck ispell)
  :custom
  (ispell-dictionary  "en_US")
  (ispell-program-name  "aspell")
  (ispell-silently-savep  t)
  (ispell-extra-args  '("--sug-mode=ultra" "--lang=en_US")))


(use-package flycheck-color-mode-line
  :config
  (flycheck-color-mode-line-mode))

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
  (setq diff-hl-flydiff-delay 1
		diff-hl-ask-before-revert-hunk nil
		)
  (custom-set-faces
   '(diff-hl-insert ((t (:background "dark green" :foreground "dark green"))))
   '(diff-hl-change ((t (:background "orange" :foreground "orange"))))
   '(diff-hl-delete ((t (:background "red" :foreground "red"))))
   )

  (global-diff-hl-mode)
  (diff-hl-flydiff-mode)
  )
(use-package highlight-numbers
  :hook (prog-mode . highlight-numbers-mode))

(use-package highlight-escape-sequences
  :hook (prog-mode . hes-mode))

(use-package valign
  :disabled t
  :hook
  ;; (org-mode . valign-mode)
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
   bongo-enabled-backends '(mpv)
   )
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
		mini-frame-resize nil
		mini-frame-resize-min-height 20
		mini-frame-resize-max-height 20
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
  ;; :bind
  ;; (("C-." . embark-act)         ;; pick some comfortable binding
  ;;  ("C-;" . embark-dwim)        ;; good alternative: M-.
  ;;  ("C-h B" . embark-bindings)) ;; alternative for `describe-bindings'
  ;; :init
  ;; (general-evil-define-key 'normal 'global "C-." 'embark-act)
  ;; (global-set-key (kbd "C-h B") 'embark-bindings)

  ;; Optionally replace the key help with a completing-read interface
  ;; (setq prefix-help-command #'embark-prefix-help-command)

  ;; Show the Embark target at point via Eldoc.  You may adjust the Eldoc
  ;; strategy, if you want to see the documentation from multiple providers.
  ;; (add-hook 'eldoc-documentation-functions #'embark-eldoc-first-target)
  ;; (setq eldoc-documentation-strategy #'eldoc-documentation-compose-eagerly)

  :config
  ;; Hide the mode line of the Embark live/completions buffers
  ;; (add-to-list 'display-buffer-alist
  ;;              '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
  ;;                nil
;;                (window-parameters (mode-line-format . none))))
)

(use-package embark-consult
  ;; :after consult
  ;; :hook
  ;; (embark-collect-mode . consult-preview-at-point-mode)
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
  (marginalia-mode)
  )

(use-package ctrlf)

(use-package popper
  :ensure t ; or :straight t
  :bind (("C-`"   . popper-toggle-latest)
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
		popper-display-control t
		popper-window-height nil
		)
  (popper-mode +1)
  (popper-echo-mode +1)

  (add-hook 'compilation-mode-hook 'exec/decrease-buffer-font)
  (add-hook 'helpful-mode-hook 'exec/decrease-buffer-font)
  (add-hook 'messages-buffer-mode-hook 'exec/decrease-buffer-font)
  )



(use-package orderless
  :init
  (setq completion-search-distance 200)
  (setq completion-styles '(
							;; partial-completion
							;; substring
							;; flex
							basic
							orderless
							;; emacs22
							)
		completion-category-defaults nil
		completion-category-overrides '((file (styles basic partial-completion)))
		)
  )



(use-package copilot
  :ensure nil
  :straight (copilot :type git :host github :repo "zerolfx/copilot.el" :files ("*.el" "dist"))
  :hook
  (prog-mode . copilot-mode)
  (org-mode . copilot-mode)
  (text-mode . copilot-mode)
  :config (setq copilot-node-executable "node"
				copilot-idle-delay 1
				copilot-max-char -1
				)
  (custom-set-faces '(copilot-overlay-face ((t (:inherit shadow :underline t :weight thin :slant italic :foreground "white")))))
;; lfjewio how to 
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
		([tab] . corfu-complete)
		("<f9>" . corfu-quit))

  :config
  (set-face-attribute 'corfu-default nil :font "JuliaMono" :background "black")
  (setq
   corfu-auto t
   corfu-auto-prefix 1
   corfu-cycle t
   corfu-preselect-first nil
   corfu-count 20
   corfu-auto-delay 0.1
   corfu-quit-no-match t
   corfu-quit-at-boundary t
   corfu-on-exact-match nil
   corfu-max-width 120
   corfu-min-width 60
   corfu-popupinfo-delay '(0.0 . 0.0)
   corfu-popupinfo-max-height 100
   corfu-preview-current nil
   )
   (global-corfu-mode)
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

(use-package corfu-terminal)

(use-package eldoc-box
  :config
  ;; (eldoc-box-hover-mode) 
  ;; (eldoc-box-hover-at-point-mode)
  )


(use-package kind-icon
  :after corfu
  :custom
  (kind-icon-default-face nil) ; to compute blended backgrounds correctly

  :config
  (setq kind-icon-use-icons t
		kind-icon-blend-frac 0
		kind-icon-default-style '(:padding 0 :stroke 0 :margin 0 :radius 0 :height 0.5 :scale 1.0)
		kind-icon-extra-space nil
		)

  ;; (setq kind-icon-default-face 'corfu-default) ; to compute blended backgrounds correctly
  (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter)
  )

(use-package all-the-icons-completion
  :config
   (all-the-icons-completion-mode))

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

  (setq cape-dabbrev-min-length 2
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
  (dabbrev-ignored-buffer-regexps '("\\.\\(?:pdf\\|jpe?g\\|png\\)\\'")))

(use-package rg
  :hook (rg-mode . (lambda()
					  (switch-to-buffer-other-window (current-buffer))
					  ))
  :config
  (setq rg-executable "rg")
  (setq rg-keymap-prefix (kbd "H-r"))
  (setq rg-show-columns nil)
  (rg-enable-default-bindings)
  (rg-enable-menu)

  (advice-add
   'rg-dwim-current-file
   :after '(lambda (&rest args) (call-interactively 'other-window))
   )


  (rg-define-search rg-search-current-file
	"Run ripgrep on current file searching"
	:dir current
	:query ask
	:format literal
	:files (rg-get-buffer-file-name)
	:dir current)
  )

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
		 ("<help> a" . consult-apropos)            ;; orig. apropos-command
		 ;; M-g bindings (goto-map)
		 ("M-g e" . consult-compile-error)
		 ("M-g f" . consult-flymake)               ;; Alternative: consult-flycheck
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

  ;; Optionally configure preview. The default value
  ;; is 'any, such that any key triggers the preview.
  ;; (setq consult-preview-key 'any)
  ;; (setq consult-preview-key (kbd "M-."))
  ;; (setq consult-preview-key (list (kbd "<S-down>") (kbd "<S-up>")))
  ;; For some commands and buffer sources it is useful to configure the
  ;; :preview-key on a per-command basis using the `consult-customize' macro.

  (setq consult-preview-key
		'(:debounce 0.3 any)
		;; 'any
		)
  (consult-customize
   consult-theme
   consult-ripgrep
   consult-git-grep
   consult-grep
   consult-bookmark
   consult-recent-file
   consult-xref
   consult--source-bookmark consult--source-recent-file
   consult--source-project-recent-file
   )
  (setq consult-async-min-input 1)
  (setq consult-async-refresh-delay 1.0)
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
		"rg --null --line-buffered --color=never --max-columns=1000 --path-separator /   --smart-case --no-heading --line-number .")

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

   (consult-preview-at-point-mode)
  )


(use-package lsp-mode
  :after evil
  :init
  (setq lsp-completion-provider :none)
  (setq lsp-diagnostics-provider :none)

  (defun exec/rust-mode-lsp-hook()
	(setq
	 lsp-rust-analyzer-diagnostics-enable-experimental t
	 lsp-rust-analyzer-display-chaining-hints t
	 lsp-rust-analyzer-display-closure-return-type-hints t
	 lsp-rust-analyzer-display-lifetime-elision-hints-enable nil
	 lsp-rust-analyzer-display-parameter-hints t
	 lsp-rust-analyzer-rustfmt-rangeformatting-enable t
	 lsp-rust-analyzer-server-display-inlay-hints t
	 )
	(lsp)
	;; (lsp-rust-analyzer-inlay-hints-mode)
	(flycheck-add-next-checker 'rust-cargo 'rust-clippy)
	(add-hook 'lsp-rust-analyzer-inlay-hints-mode-hook
			  (lambda nil
				(custom-set-faces
				 '(lsp-rust-analyzer-inlay-face
				   ((t (
						:inherit font-lock-comment-face
						;; :height 0.8
						;; :width normal
						;; :foreground "light gray"
						;; :background "dim gray"
						:underline '(:color "white" :style wave)
						)))))))
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
									 (lsp--position-to-point (gethash "start" (gethash "range" it nil)))) highlights))
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

  :bind
  ("M-i" . lsp-goto-symbol-occurence-backward)
  ("M-o" . lsp-goto-symbol-occurence-forward)
  ;; (:map lsp-ui-peek-mode-map
  ;;  ("C-j" . evil-next-line)
  ;;  ("C-k" . evil-previous-line))
  :hook
  (
   ((shell-mode clojure-mode) . lsp)
   (rust-mode . exec/rust-mode-lsp-hook)
   (rust-ts-mode . exec/rust-mode-lsp-hook)
   )
  :config

  (add-hook 'lsp-completion-mode-hook (lambda()
							(setq completion-category-defaults nil)))
  (add-hook 'lsp-mode-hook (lambda()
				 (let ((lsp-keymap-prefix "C-c l"))
				   (lsp-enable-which-key-integration))
							  ))


  (define-key lsp-mode-map (kbd "C-c l") lsp-command-map)

  (evil-add-command-properties #'lsp-find-type-definition :jump t)
  (evil-add-command-properties #'lsp-find-definition :jump t)
  (evil-add-command-properties #'goto-line :jump t)

  (setq
   lsp-enable-indentation nil
   lsp-enable-on-type-formatting nil
   lsp-enable-symbol-highlighting t
   lsp-enable-text-document-color t
   lsp-headerline-breadcrumb-enable-diagnostics nil
   lsp-idle-delay 1
   lsp-lens-enable nil
   lsp-log-io nil
   lsp-references-exclude-definition nil
   lsp-response-timeout nil
   lsp-semantic-tokens-enable nil
   lsp-ui-doc-show-with-cursor t
   lsp-ui-doc-delay 1.0
   lsp-ui-doc-header t
   lsp-ui-doc-use-childframe t
   lsp-ui-doc-use-webkit nil
   lsp-ui-doc-include-signature t
   lsp-ui-doc-position 'top
   lsp-ui-sideline-enable nil
   lsp-completion-sort-initial-results nil
   lsp-eldoc-render-all nil
   lsp-eldoc-enable-hover nil

   lsp-completion-no-cache nil
   lsp-enable-snippet t

   lsp-references-exclude-definition t
   lsp-inlay-hint-enable t
   )

  ;; lsp-bash
  (setq lsp-bash-explainshell-endpoint "https://explainshell.com"
		lsp-bash-highlight-parsing-errors t)


  (setq lsp-pylsp-plugins-yapf-enabled t
		lsp-pylsp-plugins-flake8-enabled t
		lsp-pylsp-plugins-pylint-enabled t)

 ;; (setq assignVariableTypes "assignVariableTypes")
  (lsp-register-custom-settings '(
								  ("gopls.allExperiments" t t)
								  ("gopls.completeUnimported" t t)
								  ("gopls.staticcheck" t t)
								  ("gopls.usePlaceholders" t t)
								  ("gopls.allExperiments" t t)

								  ("gopls.hints" ((assignVariableTypes . t)
												  (compositeLiteralFields . t)
												  (compositeLiteralTypes . t)
												  (functionTypeParameters . t)
												  (parameterNames . t)
												  (rangeVariableTypes . t)
												  )
								   )
								  )
								)



  (evil-define-key 'normal lsp-mode-map
	(kbd "gd") 'lsp-find-definition
	(kbd "M-b") 'lsp-find-definition
	(kbd "gD") 'lsp-find-declaration
	(kbd "gt") 'lsp-find-type-definition
	(kbd "gr") 'lsp-find-references
	(kbd "gi") 'lsp-find-implementation
	)

  (setq lsp-zig-zls-executable "zls")
  )


(use-package lsp-ui
  :config
  (setq lsp-imenu-sort-methods nil)
  ;; (custom-set-faces 
  ;;  '(lsp-ui-menu ((t (:inherit default :background "#282c34"))))
  ;;  '(lsp-ui-sideline-global ((t (:family "Iosevka" :height 1.0 :width ultra-condensed))))
  ;;  )

  (add-hook 'lsp-ui-imenu-mode-hook
			'(lambda()
			   (interactive)
			   (setq buffer-face-mode-face '(
											 :family "Iosevka"
											 :height 100))
			   (buffer-face-mode)
			   ))
  )
(use-package lsp-grammarly)

(use-package consult-lsp
  :after consult
  )
(use-package lsp-pyright
  :config
  (setq lsp-pyls-server-command "pyright")
  )

(use-package yasnippet
  :hook (after-init . yas-global-mode)
  :config
  (yas-reload-all)
  (use-package yasnippet-snippets
	:after yasnippet)
  )


;; (use-package lsp-bridge
;;   :ensure nil
;;   :straight (lsp-bridge :type git
;; 			  :host github
;; 			  :repo "manateelazycat/lsp-bridge"
;; 			  :files ("*"))
;;   :config
;;   (general-evil-define-key 'normal 'lsp-bridge-ref-mode-map 
;; 	"q" 'lsp-bridge-ref-quit
;; 	"C-j" 'lsp-bridge-ref-jump-next-file
;; 	"C-k" 'lsp-bridge-ref-jump-prev-file
;; 	"RET" 'lsp-bridge-ref-open-file-and-stay
;; 	"SPC" 'lsp-bridge-ref-open-file
;; 	)

;;   (general-evil-define-key 'normal 'lsp-bridge-mode-map 
;; 	"C-j" 'next-line
;; 	"C-k" 'previous
;; 	"gd" 'lsp-bridge-find-def
;; 	"gt" 'lsp-bridge-find-type-def
;; 	"gr" 'lsp-bridge-find-references
;; 	"gR" 'lsp-bridge-find-def-return
;; 	"gi" 'lsp-bridge-find-impl
;; 	)

;;   (global-lsp-bridge-mode)
;;   ) 



(use-package keycast
  :hook (after-init . keycast-tab-bar-mode)
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




(add-hook 'dired-mode-hook '(lambda()
							  ;; set font for buffer
							  (interactive)
							  (setq buffer-face-mode-face '(:family "Noto Sans Mono" ))
							  (buffer-face-mode)
							  ))




(add-hook 'org-mode-hook '(lambda()
							(set-face-attribute 'org-block nil :font "Noto Sans Mono")
							(set-face-attribute 'org-verbatim nil :font "Noto Sans Mono" :foreground "orange")

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
  )

(use-package exercism
  ;; :straight (exercism.el :type git :host github
  ;; 				   :repo "anonimitoraf/exercism.el"
  ;; 				   )
  :config
  (setq exercism-directory "~/Projects/github.com/eval-exec/exercism")
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

(use-package bufler)

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
(add-hook 'compilation-mode-hook 'ansi-color-for-comint-mode-on)
(add-to-list 'comint-output-filter-functions 'ansi-color-process-output)

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


(use-package perspective
  :bind
  ("C-x C-b" . persp-list-buffers)         ; or use a nicer switcher, see below
  :init
  ;;  (persp-mode)
  )



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

(use-package slime
  :disabled t
  :config (setq inferior-lisp-program "sbcl"))


(use-package rust-playground
  :config
  (setq rust-playground-cargo-toml-template
		"[package]\nname = \"rust-playground\"\nversion = \"0.1.0\"\nauthors = [\"Eval EXEC<execvy@gmail.com>\"]\nedition = \"2021\"\n\n[dependencies]"
		rust-playground-confirm-deletion nil
		)
  )
(use-package cargo-mode)
(use-package js2-mode)

(use-package emr
  :bind
  (
   ("M-RET" . 'emr-show-refactor-menu)
   )
  )


(use-package tree-sitter-langs)
;; (use-package tree-sitter-indent)
;; (use-package tree-sitter)

(use-package magit
  :config
 (use-package forge)
  )

(use-package git-commit)

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
  :config
  (setq help-window-select t)
   )

(use-package 2048-game)

(use-package super-save
  :config
  (super-save-mode +1)
  (setq super-save-auto-save-when-idle t)
  (setq auto-save-default nil)
  )


(use-package hungry-delete
  :config
  (global-hungry-delete-mode -1)
  )


(defun exec/nov-mode-face()
  (interactive)

  (setq buffer-face-mode-face '(
								;; :family "Noto Sans"
								:height 1.5
								;; :background "white"
								;; :foreground "black"
								))
  (make-local-variable 'buffer-face-mode-face)
  (buffer-face-mode)
  (blink-cursor-mode -1)
  )

(use-package nov
  :hook
  (nov-mode . exec/nov-mode-face)
  (nov-mode . writeroom-mode)
  :config
  (setq nov-unzip-program "unzip"
		nov-text-width t
		visual-fill-column-center-text nil
		)
  (add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode))
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
  :config
  )
(use-package better-scroll
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
  (pangu-spacing-inhibit-mode-alist  '(eshell-mode shell-mode term-mode))
  :config
   (global-pangu-spacing-mode)
  )

(use-package eglot
  :disabled t
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
  (setq telega-server-libs-prefix "/nix/store/cnvn9jsls70idm7cd981s4qr20pry3rv-tdlib-1.8.16")
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
  :straight (:type built-in)
  :config


  (setq mu4e-mu-binary (executable-find "mu"))
  ;; use mu4e for e-mail in emacs
  (setq mail-user-agent 'mu4e-user-agent)

										; (setq mu4e-drafts-folder "/[Gmail].Drafts")
										; (setq mu4e-sent-folder   "/[Gmail].Sent")
										; (setq mu4e-trash-folder  "/[Gmail].Trash")

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

  ;; allow for updating mail using 'U' in the main view:
  (setq mu4e-get-mail-command "true"
		mu4e-index-update-in-background nil
		mu4e-update-interval nil
		mu4e-index-cleanup t
		mu4e-index-lazy-check nil
		mu4e-notification-support t
		mu4e-speedbar-support t
		)


  (setq mu4e-use-fancy-chars nil
		mu4e-debug t
		)
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
  (setq ement-notify-dbus-p nil)
  (defun exec/ement-connect ()
	(interactive)
	(ement-connect
	 :user-id "@evil-neo:matrix.org"
	 :uri-prefix "https://matrix.org"))

  (setq ement-room-message-format-spec 
		"[%S%L]: %B%r%R%t"
ement-room-list-column-Name-max-width 40
ement-room-left-margin-width 24
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
  :hook
  (prog-mode . format-all-mode)

  ;; (prog-mode . format-all-ensure-formatter)
  ;; (emacs-lisp-mode . format-all-ensure-formatter)
  :config
  (setq format-all-show-errors 'error)

  ;; select yapf as the default formatter for python
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
		affe-find-command "fd "
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

(use-package markdown-mode
  :config
  (setq markdown-fontify-code-blocks-natively t)
  )

(use-package hackernews
  :config
  (setq hackernews-items-per-page 50)

  )

(setq epg-pinentry-mode nil)
(epa-file-enable)

(use-package org
;;   :hook (
;; 		 (before-save . skx-org-mode-before-save-hook)
;; 		 (org-trigger . save-buffer)
;; 		 )
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

;; (org-agenda-include-diary . t)
(setq org-agenda-time-grid '((daily today require-timed)
							 (000 100 200 300 400 500 600 700 800 900 1000 1100 1200 1300 1400 1500 1600 1700 1800 1900 2000 2100 2200 2300 2400)
							 "......"
							 "----------------"))
(setq org-done-keywords-for-agenda nil)
(setq org-agenda-use-tag-inheritance  t)
(setq org-agenda-window-setup 'current-window)
(setq org-agenda-restore-windows-after-quit  t)

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

;; (use-package org-super-agenda
;;   )

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
  (set-face-font 'org-modern-symbol "Symbola")
  (global-org-modern-mode)
  )
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
  (org-yaap-mode 1))
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

  (add-hook 'gts-after-buffer-render-hook ;; use 'gts-after-buffer-multiple-render-hook instead if you have multiple engines
			(defun your-hook-that-disable-evil-mode-in-go-translate-buffer (&rest _)
			  (evil-emacs-state)
			  (exec/go-translate-mode-no-mono)
			  ))
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
  :hook makefile-mode
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
									  ))
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


  (use-package projectile-ripgrep
	:config
	)
   (projectile-mode)
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
   treemacs-deferred-git-apply-delay  0.1
   treemacs-file-event-delay          0.1
   treemacs-file-follow-delay         0.1
   treemacs-tag-follow-delay          0.1
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
		  treemacs-indentation 0
		  treemacs-indentation-string            ""
		  treemacs-is-never-other-window nil
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
		  treemacs-user-header-line-format nil
		  treemacs-width                         35
		  treemacs-workspace-switch-cleanup nil)

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
  :bind(("M-0"       . treemacs-select-window)
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
  :disabled t
  :after (treemacs projectile)
  )



(use-package treemacs-magit
  :disabled t
  :after (treemacs magit)
  )


(use-package tab-bar
  :init
  (defun exec/tab-bar-mode-hook()
	(interactive)
	(setq 
	 tab-bar-format '(tab-bar-format-history
					  tab-bar-format-tabs-groups
					  tab-bar-format-tabs
					  tab-bar-separator
					  tab-bar-format-add-tab
					  tab-bar-format-align-right
					  ))

	(setq tab-bar-format (delete-dups tab-bar-format))
	(set-face-attribute 'tab-bar nil :weight 'thin :height 1.0))
(defun exec/name-tab-by-project-or-default ()
  "Return project name if in a project, or default tab-bar name if not.
The default tab-bar name uses the buffer name."
  (let ((project-name (projectile-project-name)))
    (if (string= "-" project-name)
        (tab-bar-tab-name-current)
      (projectile-project-name))))

  :hook
  (after-init . tab-bar-mode)
  (after-init . tab-bar-history-mode)
  (tab-bar-mode . exec/tab-bar-mode-hook)
  :config
  (setq tab-bar-close-button-show nil
		tab-bar-separator " "
		tab-bar-border 0
		tab-bar-button-margin 0
		tab-bar-auto-width nil
		tab-bar-tab-name-function 'tab-bar-tab-name-current
		)
  (setq tab-bar-format (delete-dups tab-bar-format))
  )

(use-package tab-line-mode
  :straight (:type built-in)
  (setopt tab-line-close-button-show nil)
  )

(use-package tabspaces)

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
(use-package color-theme-sanityinc-tomorrow)
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
  (setq which-key-frame-max-width 1000)
  (setq which-key-frame-max-height 2000)
  (setq which-key-idle-delay 0.3)
  (setq which-key-idle-secondary-delay 0)
  (setq which-key-max-description-length nil)
  (setq which-key-side-window-max-height 1000)
  (setq which-key-allow-evil-operators t)
  (setq which-key-sort-order
		;; 'which-key-prefix-then-key-order-reverse
		'which-key-description-order
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
		)
  (which-key-posframe-mode)
  )




(use-package olivetti
  :config)


(use-package highlight-defined
  :hook
  (emacs-lisp-mode . highlight-defined-mode))

(use-package w3m
  :straight (:type built-in)
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
		)
  
  )
(use-package eww
  :straight (:type built-in)
;; https://www.google.com/search?q=%s&pws=0&gl=us&gws_rd=cr

  :config
  (setq eww-search-prefix "https://www.google.com/search?pws=0&gl=us&gws_rd=cr&q="
		eww-retrieve-command nil
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
  :config

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

(setq inferior-lisp-program "/usr/bin/sbcl")
(use-package sly
  :config
  )
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
   '(org-modern-symbol  ((t  (:inherit  org-modern-symbol :family "JuliaMono"  :height  1.0))))
   '(org-verbatim       ((t  (:inherit  org-verbatim      :family "JuliaMono"  :height  1.0))))
   '(org-block          ((t  (:inherit  org-block         :family "JuliaMono"  :height  1.0))))
   '(org-table          ((t  (:inherit  org-table :family "JuliaMono"  :height  1.0))))
   )
  (setq-local buffer-face-mode-face '(:height 1.0))
  (buffer-face-mode))

;; (set-face-attribute 'fixed-pitch nil :family "SomeFont" :inherit 'default)

(defun exec/open-in-tmux()
  (interactive)
  (shell-command (concat "tmux new-window -c \"" default-directory "\""))
  )


(add-hook 'org-mode-hook 'exec/increase-buffer-font)
(add-hook 'org-journal-mode-hook 'exec/increase-buffer-font)

(defun exec/non-mono-font()
  (interactive)
  (setq-local buffer-face-mode-face '(:family "Noto Sans"))
  (buffer-face-mode))

(add-hook 'org-mode-hook 'exec/non-mono-font)
(add-hook 'org-journal-mode-hook 'exec/non-mono-font)

(add-hook 'prog-mode-hook 'exec/increase-buffer-font)
(add-hook 'prog-mode-hook 'exec/prog-mode-fixed)

(add-hook 'prog-mode-hook 'display-line-numbers-mode)
;; (add-hook 'text-mode-hook 'display-line-numbers-mode)
;; (add-hook 'toml-mode-hook 'display-line-numbers-mode)
;; (add-hook 'conf-mode-hook 'display-line-numbers-mode)
;; (add-hook 'consult-preview-at-point-mode-hook 'display-line-numbers-mode)
;; (add-hook 'ssh-config-mode-hook 'display-line-numbers-mode)
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
  ;; :hook (deadgrep-mode . next-error-follow-minor-mode)
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

  ;; (defun deadgrep-preview-result()
  ;; 	"Goto the search result at point, opening it in a specific window which named deadgrep-preview."
  ;; 	(interactive)
  ;; 	(deadgrep--visit-result #'find-file-in-other-window-with-prefix-buffer-name))
  )

(use-package color-rg
  :ensure nil
  :straight (color-rg :type git :host github :repo "manateelazycat/color-rg")
  )

;; (add-to-list 'load-path "~/.emacs.d/elisp/blink-search")
;; (require 'blink-search)

(use-package awesome-tray
  :disabled t
  :straight (:host github :repo "manateelazycat/awesome-tray")
  )

;; (use-package holo-layer
;;   :ensure nil
;;   :disabled t
;;   :straight (:host github :repo "manateelazycat/holo-layer" :files ("*.el" "*.py" "plugin" "resources"))
;;   :config
;;   (holo-layer-enable)
;;   (setq holo-layer-python-command "/home/exec/.emacs.d/straight/repos/holo-layer/.venv/bin/python3"
;; 		holo-layer-enable-cursor-animation t
;; 		holo-layer-cursor-animation-type "jelly"
;; 		holo-layer-cursor-animation-duration 200
;; 		holo-layer-cursor-animation-interval 10
;; 		holo-layer-hide-mode-line nil
;; 		holo-layer-cursor-color "blue"
;; 		holo-layer-cursor-alpha 220
;; 		holo-layer-enable-debug nil
;; 		holo-layer-enable-place-info nil
;; 		)
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
(setq compilation-environment '("TERM=xterm-256color"))
(defun my/advice-compilation-filter (f proc string)
  (funcall f proc (xterm-color-filter string)))

(advice-add 'compilation-filter :around #'my/advice-compilation-filter)

(use-package ansi-color
  :config
  (defadvice display-message-or-buffer (before ansi-color activate)
	"Process ANSI color codes in shell output."
	(let ((buf (ad-get-arg 0)))
	  (and (bufferp buf)
		   (string= (buffer-name buf) "*Shell Command Output*")
		   (with-current-buffer buf
			 (ansi-color-apply-on-region (point-min) (point-max))))))

  (custom-set-faces '(ansi-color-black ((t ( :foreground "#696969" :background "#696969")))))
  (custom-set-faces '(ansi-color-white ((t ( :foreground "#d9d9d9" :background "#d9d9d9")))))

  )


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

(use-package explain-pause-mode)

(use-package wakatime-mode
  :config
  (setq wakatime-cli-path "/run/current-system/sw/bin/wakatime-cli")
  (global-wakatime-mode)
  )

(use-package wordreference
  :config
  (setq wordreference-source-lang "en")
  )

(use-package python-mode)
(use-package clojure-mode)
(use-package typescript-mode)
(use-package rust-mode
  :mode "\\.rs\\'"
  )

(use-package go-mode
  :config
  (use-package go-impl)
  (use-package go-guru)
  (use-package go-playground)
  (use-package go-expr-completion
	)
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
  :hook
  (
  (gptel-mode . (lambda()
				  (copilot-mode -1)
				  (exec/sans-mode)
				  ))
   )
  :config
  (defun exec/gptel-send()
	(interactive)
	;; insert a space
	(insert " ")
	(evil-normal-state)
	(gptel-send )
	)
  (general-define-key
   :keymaps 'gptel-mode-map
   "C-<return>" 'exec/gptel-send
   "C-c C-k" 'gptel-abort
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
		gptel-directives '((default .
									"You are a large language model living in Emacs and a helpful assistant. Respond concisely. Your reponse paragram should prefixed with `🤖:: ` please")
						   (programming .
										"You are a large language model and a careful programmer. Provide code and only code as output without any additional text, prompt or note.")
						   (writing .
									"You are a large language model and a writing assistant. Respond concisely.")
						   (chat .
								 "You are a large language model and a conversation partner. Respond concisely."))

		)
  )

(use-package chatgpt
  :straight (:host github :repo "joshcho/ChatGPT.el" :files ("dist" "*.el"))
  :init
  (require 'python)
  (setq chatgpt-repo-path "~/.emacs.d/straight/repos/ChatGPT.el/")
  :bind ("C-c q" . chatgpt-query))

(defun exec/vterm-buffer-face()
  (interactive)
  (setq-local  buffer-face-mode-face '(
									   ;; :family "Noto Sans Mono"
									   ;; "NotoSansMNerdFontMono"
									   ;; :family "JetBrainsMonoNL Nerd Font"
									   :height  100
									   :background "black"
									   )
			   mode-line-format nil
			   )
  (buffer-face-mode)
  (origami-mode -1)
  (fringe-mode -1)
  ;; (set-left-margin 0)
  ;; (set-right-margin 0)
  )

(use-package vterm
  ;; :bind ("C-<return>" . vterm-send-return)
  :hook (vterm-mode  . exec/vterm-buffer-face)
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

  (setq vterm-always-compile-module t
		vterm-set-bold-hightbright t)
  (set-face-attribute 'vterm-color-blue nil :foreground "#268bd2" :background "#268bd2")
  (set-face-attribute 'vterm-color-black nil :foreground "gray"    :background "dim gray")
  )

(use-package fcitx
  :after evil
  :config
  (setq fcitx-remote-command "fcitx5-remote")
  (fcitx-prefix-keys-turn-off)
  (fcitx-default-setup))


(use-package rime
  :straight (:type built-in)
  :init
  (setq rime-show-candidate 'posframe
		default-input-method "rime"
		)
  (setq rime-user-data-dir "~/.local/share/fcitx5/rime")
  :bind ("s-=" . 'toggle-input-method)
  :config
  (setq rime-posframe-properties
		(list :font "Noto Sans CJK SC"
			  :internal-border-width 1))
  (setq rime-show-preedit t)
  )



;; (global-set-key (kbd "s-=") 'toggle-input-method)
;; (setq default-input-method "rime")




;; (global-set-key (kbd "s-=") (lambda()
;; 			      (interactive)
;; 			      (shell-command "/usr/bin/fcitx-remote -t")
;; 			      ))

(unless (server-running-p)
  (server-start)
  )
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

(use-package imenu-list
  :ensure nil
  :straight (imenu-list :type git :host github :repo "bmag/imenu-list")
  :config
  ;; (imenu-list-minor-mode)
  )



(use-package hl-line
  :disabled t
  :config
  (set-face-attribute 'hl-line nil :background "#000000")
  ;; :global-minor-mode global-hl-line-mode
  )

(use-package hl-line+
  :hook
  (window-scroll-functions . hl-line-flash)
  (focus-in . hl-line-flash)
  ;; (post-command . hl-line-flash)

  :custom
  (global-hl-line-mode nil)
  (hl-line-flash-show-period 0.5)
  (hl-line-inhibit-highlighting-for-modes '(dired-mode))
  (hl-line-overlay-priority -100) ;; sadly, seems not observed by diredfl
  )
