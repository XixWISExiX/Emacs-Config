(defvar elpaca-installer-version 0.11)
(defvar elpaca-directory (expand-file-name "elpaca/" user-emacs-directory))
(defvar elpaca-builds-directory (expand-file-name "builds/" elpaca-directory))
(defvar elpaca-repos-directory (expand-file-name "repos/" elpaca-directory))
(defvar elpaca-order '(elpaca :repo "https://github.com/progfolio/elpaca.git"
                              :ref nil :depth 1 :inherit ignore
                              :files (:defaults "elpaca-test.el" (:exclude "extensions"))
                              :build (:not elpaca--activate-package)))
(let* ((repo  (expand-file-name "elpaca/" elpaca-repos-directory))
       (build (expand-file-name "elpaca/" elpaca-builds-directory))
       (order (cdr elpaca-order))
       (default-directory repo))
  (add-to-list 'load-path (if (file-exists-p build) build repo))
  (unless (file-exists-p repo)
    (make-directory repo t)
    (when (<= emacs-major-version 28) (require 'subr-x))
    (condition-case-unless-debug err
        (if-let* ((buffer (pop-to-buffer-same-window "*elpaca-bootstrap*"))
                  ((zerop (apply #'call-process `("git" nil ,buffer t "clone"
                                                  ,@(when-let* ((depth (plist-get order :depth)))
                                                      (list (format "--depth=%d" depth) "--no-single-branch"))
                                                  ,(plist-get order :repo) ,repo))))
                  ((zerop (call-process "git" nil buffer t "checkout"
                                        (or (plist-get order :ref) "--"))))
                  (emacs (concat invocation-directory invocation-name))
                  ((zerop (call-process emacs nil buffer nil "-Q" "-L" "." "--batch"
                                        "--eval" "(byte-recompile-directory \".\" 0 'force)")))
                  ((require 'elpaca))
                  ((elpaca-generate-autoloads "elpaca" repo)))
            (progn (message "%s" (buffer-string)) (kill-buffer buffer))
          (error "%s" (with-current-buffer buffer (buffer-string))))
      ((error) (warn "%s" err) (delete-directory repo 'recursive))))
  (unless (require 'elpaca-autoloads nil t)
    (require 'elpaca)
    (elpaca-generate-autoloads "elpaca" repo)
    (let ((load-source-file-function nil)) (load "./elpaca-autoloads"))))
(add-hook 'after-init-hook #'elpaca-process-queues)
(elpaca `(,@elpaca-order))

;; Install a package via the elpaca macro
;; See the "recipes" section of the manual for more details.

;; (elpaca example-package)

;; Install use-package support
(elpaca elpaca-use-package
  ;; Enable use-package :ensure support for Elpaca.
  (elpaca-use-package-mode))

;;When installing a package used in the init file itself,
;;e.g. a package which adds a use-package key word,
;;use the :wait recipe keyword to block until that package is installed/configured.
;;For example:
;;(use-package general :ensure (:wait t) :demand t)

;; Expands to: (elpaca evil (use-package evil :demand t))
;;(use-package evil :ensure t :demand t)
(use-package evil
    :ensure t
    :init ;; tweak evil's configuration before loading it
    (setq evil-want-integration t) ;; This is optional since it's already set to true
    (setq evil-want-keybinding nil)
    (setq evil-vsplit-window-right t)
    (setq evil-split-window-below t)
    (evil-mode))

(use-package evil-collection
    :ensure t
    :after evil
    :config
    (setq evil-collection-mode-list '(dashboard dired ibuffer))
    (evil-collection-init))

(use-package evil-tutor :ensure t)

;;Turns off elpaca-use-package-mode current declaration
;;Note this will cause evaluate the declaration immediately. It is not deferred.
;;Useful for configuring built-in emacs features.
(use-package emacs :ensure nil :config (setq ring-bell-function #'ignore))

;; "gx" allows you to click an https link.
(defun my/gx-smart-open ()
  "Open URL or Org link depending on context."
  (interactive)
  (cond
   ((eq major-mode 'org-mode)
    (org-open-at-point))
   (t
    (browse-url-at-point))))

;; Package to allow undo and redo with VIM keybinds
(use-package undo-fu
  :ensure t)

(with-eval-after-load 'evil
  (define-key evil-normal-state-map "gx" #'my/gx-smart-open) ;; link opener
  (setq evil-undo-system 'undo-fu)
  (define-key evil-normal-state-map (kbd "u") #'undo-fu-only-undo)
  (define-key evil-normal-state-map (kbd "C-r") #'undo-fu-only-redo)
  ;; Set up VIM half-page up keybind in normal mode
  (define-key evil-normal-state-map (kbd "C-u") 'evil-scroll-up)
  (define-key evil-visual-state-map (kbd "C-u") 'evil-scroll-up))


;; General Keybinds
(use-package general
    :ensure t
    :config
    (general-evil-setup)
    
    ;; set up 'SPC' as the global leader key
    (general-create-definer dt/leader-keys
    :states '(normal insert visual emacs)
    :keymaps 'override
    :prefix "SPC" ;; set leader
    :global-prefix "M-SPC") ;; access leader in insert mode
    
    (dt/leader-keys
      "SPC" '(perspective-map :wk "Perspective") ;; Lists all the perspective keybindings
      "." '(find-file :wk "Find file")
      "=" '(counsel-M-x :wk "Counsel M-x")
      "f c" '((lambda () (interactive) (find-file "~/.config/emacs/config.org")) :wk "Edit emacs config")
      "f m" '((lambda () (interactive) (find-file "~/Desktop/MainFolder/Work/Research/notes/research.org")) :wk "Main Reseach Page")
      "f r" '(counsel-recentf :wk "Find recent files")
      "TAB TAB" '(comment-line :wk "Comment lines"))

    
    (dt/leader-keys
      "b" '(:ignore t :wk "buffer")
      "b b" '(switch-to-buffer :wk "Switch buffer")
      "b i" '(ibuffer :wk "Ibuffer")
      "b k" '(kill-this-buffer :wk "Kill this buffer")
      "b n" '(next-buffer :wk "Next buffer")
      "b p" '(previous-buffer :wk "Previous buffer")
      "b r" '(revert-buffer :wk "Reload buffer"))
      
    (dt/leader-keys
      "d" '(:ignore t :wk "Dired")
      "d d" '(dired :wk "Open dired")
      "d j" '(dired-jump :wk " Dired jump to current")
      "d n" '(neotree-dir :wk "Open directory in neotree")
      "d p" '(peep-dired :wk "Peep-dired")) ;; May need to spam esc key too to see images
      
    (dt/leader-keys
      "e" '(:ignore t :wk "Eshell/Evaluate/EWW")
      "e b" '(eval-buffer :wk "Evaluate elisp in buffer")
      "e d" '(eval-defun :wk "Evaluate defun containing or after point")
      "e e" '(eval-expression :wk "Evaluate an elisp expression")
      "e h" '(counsel-esh-history :wk "Eshell history")
      ;;"e h" '(counsel-esh-expression :wk "Eshell history")
      "e l" '(eval-last-sexp :wk "Evaluate elisp expression before point")
      "e r" '(eval-region :wk "Evaluate elisp in region")
      "e s" '(eshell :wk "Eshell")
      "e w" '(eww :wk "Open EWW")) ;; INTERNET SEARCH ENGINE

    ;; More commands on repo inspired repo
    (dt/leader-keys
      "g" '(:ignore t :wk "Git")
      "g t" '(git-timemachine :wk "Git time machine"))
      
    (dt/leader-keys
      "h" '(:ignore t :wk "Help")
      "h f" '(describe-function :wk "Describe function")
      "h v" '(describe-variable :wk "Describe variable")
      "h r r" '((lambda () (interactive)
                  (load-file "~/.config/emacs/init.el")
                  (ignore (elpaca-process-queues)))
                :wk "Reload emacs config"))
      ;;"h r r" '(reload-init-file :wk "Reload emacs config"))

;;    (dt/leader-keys
;;      "m d" '(:ignore t :wk "Markdown")
;;      "m d r" '(my/toggle-markdown-preview-eww :wk "Markdown Render"))
      
    (dt/leader-keys
      "m" '(:ignore t :wk "Org")
      "m a" '(org-agenda :wk "Org agenda")
      "m e" '(org-export-dispatch :wk "Org export dispatch")
      "m i" '(org-toggle-item :wk "Org toggle item")
      "m t" '(org-todo :wk "Org todo")
      "m B" '(org-babel-tangle :wk "Org babel tangle")
      "m T" '(org-todo-list :wk "Org todo list"))
     
    (dt/leader-keys
      "m b" '(:ignore t :wk "Tables")
      "m b -" '(org-table-insert-hline :wk "Insert hline in table"))

    (dt/leader-keys
      "m d" '(:ignore t :wk "Date/deadline/Markdown")
;;      "m d r" '(my/toggle-markdown-preview-eww :wk "Markdown Render")
      "m d t" '(org-time-stamp :wk "Org time stamp"))
      
    (dt/leader-keys
      "s" '(:ignore t :wk "Search")
      "s t" '(tldr :wk "TLDR"))

    (dt/leader-keys
      "t" '(:ignore t :wk "Toggle")
      "t f" '(my/toggle-buffer-fullscreen :wk "Toggle Full Buffer") ;; Make buffer go full screen and not full screen
      "t h" '(my/toggle-org-eager-fontification :wk "Toggle Org Fontification") ;; Useful for code highlight rendering
      "t n" '(display-line-numbers-mode :wk "Toggle line numbers")
      "t c" '(my/toggle-line-numbers :wk "Toggle relative line numbers")

      "t l" '(visual-line-mode :wk "Toggle truncated lines")
      "t t" '(my/toggle-theme :wk "Toggle Theme")
      "t v" '(vterm-toggle :wk "Toggle vterm"))
      ;;"t v" '(vterm :wk "Open vterm"))

    (dt/leader-keys
      "w" '(:ignore t :wk "Windows")
      ;; Window splits
      "w c" '(evil-window-delete :wk "Close Window")
      "w n" '(evil-window-new :wk "New Window")
      "w s" '(evil-window-split :wk "Horizontal split window")
      "w v" '(evil-window-vsplit :wk "Vertical split window")
      ;; Window motions
      "w h" '(evil-window-left :wk "Window left")
      "w j" '(evil-window-down :wk "Window down")
      "w k" '(evil-window-up :wk "Window up")
      "w l" '(evil-window-right :wk "Window right")
      "w w" '(evil-window-next :wk "Goto next window")
      ;; Move Windows
      "w H" '(buf-move-left :wk "Buffer move left")
      "w J" '(buf-move-down :wk "Buffer move down")
      "w K" '(buf-move-up :wk "Buffer move up")
      "w L" '(buf-move-right :wk "Buffer move right"))


    )

(use-package all-the-icons
  :ensure t
  :if (display-graphic-p))
  
(use-package all-the-icons-dired
  :ensure t
  :hook (dired-mode . (lambda () (all-the-icons-dired-mode t))))

;; Set default browser
(setq browse-url-browser-function 'browse-url-firefox)
;;(setq browse-url-browser-function 'eww-browse-url)

;;(use-package app-launcher
;;  :ensure t
;;  :elpaca '(app-launcher :host github :repo "SebastienWae/app-launcher"))
  
(elpaca (app-launcher :host github :repo "SebastienWae/app-launcher")
  (use-package app-launcher
    :defer t))

;; create a global keyboard shortcut with the following code
;; emacsclient -cF "((visibility . nil))" -e "(emacs-run-launcher)"
(defun emacs-run-launcher ()
  "Create and select a frame called emacs-run-launcher which consists only of a minibuffer and has specific dimensions. Runs app-launcher-run-app on that frame, which is an emacs command that prompts you to select an app and open it in a dmenu like behaviour. Delete the frame after that command has exited"
  (interactive)
  (with-selected-frame 
    (make-frame '((name . "emacs-run-launcher")
                  (minibuffer . only)
                  (fullscreen . 0) ; no fullscreen
                  (undecorated . t) ; remove title bar
                  ;;(auto-raise . t) ; focus on this frame
                  ;;(tool-bar-lines . 0)
                  ;;(menu-bar-lines . 0)
                  (internal-border-width . 10)
                  (width . 80)
                  (height . 11)))
                  (unwind-protect
                    (app-launcher-run-app)
                    (delete-frame))))

(setq make-backup-files nil) ; Don't create `~` backup files
;;(setq backup-directory-alist '((".*" . "~/.local/share/Trash/files"))) ; Store backup files in trash directory

(require 'windmove)

;;;###autoload
(defun buf-move-up ()
  "Swap the current buffer and the buffer above the split.
If there is no split, ie now window above the current one, an
error is signaled."
;;  "Switches between the current buffer, and the buffer above the
;;  split, if possible."
  (interactive)
  (let* ((other-win (windmove-find-other-window 'up))
	 (buf-this-buf (window-buffer (selected-window))))
    (if (null other-win)
        (error "No window above this one")
      ;; swap top with this one
      (set-window-buffer (selected-window) (window-buffer other-win))
      ;; move this one to top
      (set-window-buffer other-win buf-this-buf)
      (select-window other-win))))

;;;###autoload
(defun buf-move-down ()
"Swap the current buffer and the buffer under the split.
If there is no split, ie now window under the current one, an
error is signaled."
  (interactive)
  (let* ((other-win (windmove-find-other-window 'down))
	 (buf-this-buf (window-buffer (selected-window))))
    (if (or (null other-win) 
            (string-match "^ \\*Minibuf" (buffer-name (window-buffer other-win))))
        (error "No window under this one")
      ;; swap top with this one
      (set-window-buffer (selected-window) (window-buffer other-win))
      ;; move this one to top
      (set-window-buffer other-win buf-this-buf)
      (select-window other-win))))

;;;###autoload
(defun buf-move-left ()
"Swap the current buffer and the buffer on the left of the split.
If there is no split, ie now window on the left of the current
one, an error is signaled."
  (interactive)
  (let* ((other-win (windmove-find-other-window 'left))
	 (buf-this-buf (window-buffer (selected-window))))
    (if (null other-win)
        (error "No left split")
      ;; swap top with this one
      (set-window-buffer (selected-window) (window-buffer other-win))
      ;; move this one to top
      (set-window-buffer other-win buf-this-buf)
      (select-window other-win))))

;;;###autoload
(defun buf-move-right ()
"Swap the current buffer and the buffer on the right of the split.
If there is no split, ie now window on the right of the current
one, an error is signaled."
  (interactive)
  (let* ((other-win (windmove-find-other-window 'right))
	 (buf-this-buf (window-buffer (selected-window))))
    (if (null other-win)
        (error "No right split")
      ;; swap top with this one
      (set-window-buffer (selected-window) (window-buffer other-win))
      ;; move this one to top
      (set-window-buffer other-win buf-this-buf)
      (select-window other-win))))

(use-package company
  :ensure t
  :defer 2
  :diminish
  :custom
  (company-begin-commands '(self-insert-command))
  (company-idle-delay .1)
  (company-minimum-prefix-length 2)
  (company-show-numbers t)
  (company-tooltip-align-annotations 't)
  (global-company-mode t))

(use-package company-box
  :ensure t
  :after company
  :diminish
  :hook (company-mode . company-box-mode))

(use-package dashboard
  :ensure t 
  :init
  (setq initial-buffer-choice 'dashboard-open)
  (setq dashboard-set-heading-icons t)
  (setq dashboard-set-file-icons t)
  (setq dashboard-banner-logo-title "BRUH!")
  ;;(setq dashboard-startup-banner 'logo) ;; use standard emacs logo as banner
  (setq dashboard-startup-banner "/home/joshua/.config/emacs/images/emacs-dash.png")  ;; use custom image as banner
  (setq dashboard-center-content nil) ;; set to 't' for centered content
  (setq dashboard-items '((recents . 5)
                          (agenda . 5 )
                          (bookmarks . 3)
                          (projects . 3)
                          (registers . 3)))
  :custom
  (dashboard-modify-heading-icons '((recents . "file-text")
                                    (bookmarks . "book")))
  :config
  (dashboard-setup-startup-hook))

(use-package diminish :ensure t)

(use-package dired-open
  :ensure t
  :config
  (setq dired-open-extensions '(("gif" . "sxiv")
                                ("jpg" . "sxiv")
                                ("png" . "sxiv")
                                ("mkv" . "mpv")
                                ("mp4" . "mpv"))))

(use-package peep-dired
  :ensure t
  :after dired
  :hook (evil-normalize-keymaps . peep-dired-hook)
  :config
    (evil-define-key 'normal dired-mode-map (kbd "h") 'dired-up-directory)
    (evil-define-key 'normal dired-mode-map (kbd "l") 'dired-open-file) ; use dired-find-file instead if not using dired-open package
    (evil-define-key 'normal peep-dired-mode-map (kbd "j") 'peep-dired-next-file)
    (evil-define-key 'normal peep-dired-mode-map (kbd "k") 'peep-dired-prev-file)
)

;;(add-hook 'peep-dired-hook 'evil-normalize-keymaps)

;;(use-package elfeed
;;  :ensure t
;;  :config
;;  (setq elfeed-search-feed-face ":foreground #ffffff :weight bold"
;;        elfeed-feeds (quote
;;                       (("https://www.reddit.com/r/linux.rss" reddit linux)
;;                        ;;("https://www.reddit.com/r/commandline.rss" reddit commandline)
;;                        ;;("https://www.reddit.com/r/distrotube.rss" reddit distrotube)
;;                        ;;("https://www.reddit.com/r/emacs.rss" reddit emacs)
;;                        ;;("https://www.gamingonlinux.com/article_rss.php" gaming linux)
;;                        ;;("https://hackaday.com/blog/feed/" hackaday linux)
;;                        ;;("https://opensource.com/feed" opensource linux)
;;                        ;;("https://linux.softpedia.com/backend.xml" softpedia linux)
;;                        ;;("https://itsfoss.com/feed/" itsfoss linux)
;;                        ;;("https://www.zdnet.com/topic/linux/rss.xml" zdnet linux)
;;                        ;;("https://www.phoronix.com/rss.php" phoronix linux)
;;                        ;;("http://feeds.feedburner.com/d0od" omgubuntu linux)
;;                        ;;("https://www.computerworld.com/index.rss" computerworld linux)
;;                        ;;("https://www.networkworld.com/category/linux/index.rss" networkworld linux)
;;                        ;;("https://www.techrepublic.com/rssfeeds/topic/open-source/" techrepublic linux)
;;                        ;;("https://betanews.com/feed" betanews linux)
;;                        ;;("http://lxer.com/module/newswire/headlines.rss" lxer linux)
;;                        ("https://distrowatch.com/news/dwd.xml" distrowatch linux)))))
;; 
;;
;;(use-package elfeed-goodies
;;  :ensure t
;;  :init
;;  (elfeed-goodies/setup)
;;  :config
;;  (setq elfeed-goodies/entry-pane-size 0.5))

(require 'eww) ;; Force load now to make sure eww-mode-map exists

(with-eval-after-load 'eww
  (define-key eww-mode-map (kbd "M-h") #'eww-back-url)
  (define-key eww-mode-map (kbd "M-l") #'eww-forward-url))

(use-package flycheck
  :ensure t
  :defer t
  :diminish
  :init (global-flycheck-mode))

;; Sets fonts and sizes.
;; This code ensures that fonts are applied after 
;; all the other code (for the most part)
(when (display-graphic-p)
  (add-hook 'window-setup-hook
          (lambda ()
            (set-face-attribute 'default nil
              :font "JetBrains Mono"
              :height 110
              :weight 'medium)
            (set-face-attribute 'variable-pitch nil
              :font "Ubuntu"
              :height 120
              :weight 'medium)
            (set-face-attribute 'fixed-pitch nil
              :font "JetBrains Mono"
              :height 110
              :weight 'medium))))


;; Makes commented text and keywords italics.
;; This is working in emacsclient but not emacs.
;; Your font must have an italic face available.

(set-face-attribute 'font-lock-comment-face nil
  :slant 'italic)
(set-face-attribute 'font-lock-keyword-face nil
  :slant 'italic)  

;; This sets the default font on all graphical frames created after restarting Emacs.
;; Does the same thing as 'set-face-attribute default' above, but emacs fonts
;; are not right unless I also add this method of setting the default font.
(add-to-list 'default-frame-alist '(font . "JetBrains Mono-11"))

;; Uncomment the following line if line spacing needs adjusting.
(setq-default line-spacing 0.12)

(global-set-key (kbd "C-=") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)
(global-set-key (kbd "C-<wheel-up>") 'text-scale-increase)
(global-set-key (kbd "C-<wheel-down>") 'text-scale-decrease)

(winner-mode 1)
(defvar my/fullscreen-window-layout nil
  "Stores the winner configuration before fullscreen toggle.")

(defun my/toggle-buffer-fullscreen ()
  "Toggle full window view for the current buffer."
  (interactive)
  (if my/fullscreen-window-layout
      (progn
        (winner-undo)
        (setq my/fullscreen-window-layout nil))
    (progn
      (setq my/fullscreen-window-layout t)
      (delete-other-windows))))

(use-package git-timemachine
  :ensure t
  :after git-timemachine
  :hook (evil-normalize-keymaps . git-timemachine-hook)
  :config
    (evil-define-key 'normal git-timemachine-mode-map (kbd "C-j") 'git-timemachine-show-previous-revision)
    (evil-define-key 'normal git-timemachine-mode-map (kbd "C-k") 'git-timemachine-show-next-revision)
)

;;setq package-enable-at-startup nil)
;;(use-package magit :ensure t)
;;(require 'magit)
;;(use-package magit
;;  :ensure t
;;  :commands (magit-status magit-blame magit-log))

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

(global-display-line-numbers-mode 1)
(global-visual-line-mode t)

(defvar my/eager-org-fontify-enabled nil
  "Whether eager fontification is currently enabled in Org buffers.")

(defun my/toggle-org-eager-fontification ()
  "Toggle between lazy and eager fontification in Org mode."
  (interactive)
  (if my/eager-org-fontify-enabled
      (progn
        ;; Revert to default lazy behavior
        (setq jit-lock-defer-time 0.5)
        (setq font-lock-maximum-decoration t)
        (setq my/eager-org-fontify-enabled nil)
        (message "Org fontification: lazy mode enabled."))
    (progn
      ;; Enable eager fontification
      (setq jit-lock-defer-time nil)
      (setq font-lock-maximum-decoration t)
      (font-lock-flush)
      (font-lock-ensure)
      (setq my/eager-org-fontify-enabled t)
      (message "Org fontification: eager mode enabled."))))

;; hides the * / = ~ around styled text
(setq org-hide-emphasis-markers t) 

;; Make the dynamic latex
(setq org-startup-with-latex-preview t) ;; preview math on file open
(setq org-latex-create-formula-image-program 'dvisvgm) ;; SVGs look better than PNGs
(setq org-format-latex-options
      (plist-put org-format-latex-options :scale 1.8)) ;; Make rendered math larger

;; This gives live equation rendering: it hides LaTeX markup and shows math nicely as soon as you leave the expression
(use-package org-fragtog
  :ensure t
  :hook (org-mode . org-fragtog-mode))

(use-package hl-todo
  :ensure t
  :hook ((org-mode . hl-todo-mode)
         (prog-mode . hl-todo-mode))
  :config
  (setq hl-todo-highlight-punctuation ":"
        hl-todo-keyword-faces
        `(("TODO"       warning bold)
          ("FIXME"      error bold)
          ("HACK"       font-lock-constant-face bold)
          ("REVIEW"     font-lock-keyword-face bold)
          ("NOTE"       success bold)
          ("DEPRECATED" font-lock-doc-face bold))))

(use-package counsel
  :ensure t
  :after ivy
  :config (counsel-mode))


(use-package ivy
  :ensure t
  :bind
  ;; ivy-resume resumes the last Ivy-based completion.
  (("C-c C-r" . ivy-resume)
   ("C-x B" . ivy-switch-buffer-other-window))
  :custom
  (setq ivy-use-virtual-buffers t)
  (setq ivy-count-format "(%d/%d) ")
  (setq enable-recursive-minibuffers t)
  :config
  (ivy-mode))

(use-package all-the-icons-ivy-rich
  :ensure t
  :init (all-the-icons-ivy-rich-mode 1))

(use-package ivy-rich
  :after ivy
  :ensure t
  :init (ivy-rich-mode 1) ;; this gets us descriptions in M-x.
  :custom
  (ivy-virtual-abbreviate 'full
   ivy-rich-switch-buffer-align-virtual-buffer t
   ivy-rich-path-style 'abbrev)
  :config
  (ivy-set-display-transformer 'ivy-switch-buffer
                               'ivy-rich-switch-buffer-transformer))

;;(use-package haskell-mode)
;;(use-package lua-mode)

;; Highlighting
(use-package markdown-mode
  :ensure t
  :mode ("\\.md\\'" . markdown-mode)
  :config
  (setq markdown-command "pandoc"))

(global-set-key [escape] 'keyboard-escape-quit)

(use-package doom-modeline
  :ensure t
  :after all-the-icons
  :init (doom-modeline-mode 1)
  :config
  (setq doom-modeline-height 35      ;; sets modeline height
        doom-modeline-bar-width 5    ;; sets right bar width
        doom-modeline-persp-name t   ;; adds perspective name to modeline
        doom-modeline-persp-icon t)) ;; adds folder icon next to persp name

(use-package neotree
  :ensure t
  :config
  (setq neo-smart-open t
        neo-show-hidden-files t
        neo-window-width 55
        neo-window-fixed-size nil
        inhibit-compacting-font-caches t
        projectile-switch-project-action 'neotree-projectile-action) 
        ;; truncate long file names in neotree
        (add-hook 'neo-after-create-hook
           #'(lambda (_)
               (with-current-buffer (get-buffer neo-buffer-name)
                 (setq truncate-lines t)
                 (setq word-wrap nil)
                 (make-local-variable 'auto-hscroll-mode)
                 (setq auto-hscroll-mode nil)))))

;; show hidden files

(use-package toc-org
  :ensure t
  :commands toc-org-enable
  :init (add-hook 'org-mode-hook 'toc-org-enable))

(add-hook 'org-mode-hook 'org-indent-mode)
(use-package org-bullets :ensure t)
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))

(require 'org-tempo)

(use-package pdf-tools
  :ensure t
  :mode ("\\.pdf\\'" . pdf-view-mode)
  :init
  (pdf-loader-install)
  :config
  (evil-set-initial-state 'pdf-view-mode 'normal)
  (evil-define-key 'normal pdf-view-mode-map
    (kbd "j") 'pdf-view-next-line-or-next-page
    (kbd "k") 'pdf-view-previous-line-or-previous-page
    (kbd "l") 'image-scroll-left
    (kbd "h") 'image-scroll-right
    (kbd "f") 'pdf-view-goto-page
    (kbd "C-=") 'pdf-view-enlarge
    (kbd "C--") 'pdf-view-shrink))

  
(add-hook 'pdf-view-mode-hook #'(lambda () (interactive) (display-line-numbers-mode -1)))

;;(with-eval-after-load 'evil
;;  (evil-set-initial-state 'pdf-view-mode 'normal))

;;(define-key pdf-view-mode-map (kbd "g") #'pdf-view-goto-page)

(use-package perspective
  :ensure t
  :custom
  ;; NOTE! I have also set 'SPC SPC' to open the perspective menu.
  ;; I'm only setting the additional binding because setting it
  ;; helps suppress an annoying warning message.
  (persp-mode-prefix-key (kbd "C-c M-p"))
  :init 
  (persp-mode)
  :config
  ;; Sets a file to write to when we save states
  (setq persp-state-default-file "~/.config/emacs/sessions"))

;; This will group buffers by persp-name in ibuffer.
(add-hook 'ibuffer-hook
          (lambda ()
            (persp-ibuffer-set-filter-groups)
            (unless (eq ibuffer-sorting-mode 'alphabetic)
              (ibuffer-do-sort-by-alphabetic))))

;; Automatically save perspective states to file when Emacs exits.
(add-hook 'kill-emacs-hook #'persp-state-save)

(use-package projectile
  :ensure t
  :diminish
  :config
  (projectile-mode 1))

(use-package rainbow-delimiters
  :ensure t
  :hook ((emacs-lisp-mode . rainbow-delimiters-mode)
         (clojure-mode . rainbow-delimiters-mode)))

(defun reload-init-file ()
    (interactive)
    (load-file user-init-file)
    (load-file user-init-file))
    ;;(load-file "~/.config/emacs/init.el")
    ;;(load-file "~/.config/emacs/init.el"))

(use-package eshell-syntax-highlighting
  :ensure t
  :after esh-mode
  :diminish
  :config
  (eshell-syntax-highlighting-global-mode +1))

;; eshell-syntax-highlighting -- adds fish/zsh-like syntax highlighting.
;; eshell-rc-script -- your profile for eshell; like a bashrc for eshell.
;; eshell-aliases-file -- sets an aliases file for the eshell.
  
(setq eshell-rc-script (concat user-emacs-directory "eshell/profile")
      eshell-aliases-file (concat user-emacs-directory "eshell/aliases")
      eshell-history-size 5000
      eshell-buffer-maximum-lines 5000
      eshell-hist-ignoredups t
      eshell-scroll-to-bottom-on-input t
      eshell-destroy-buffer-when-process-dies t
      eshell-visual-commands'("bash" "fish" "htop" "ssh" "top" "zsh"))

(use-package vterm
:ensure t
:config
(setq shell-file-name "/bin/bash"
     vterm-max-scrollback 5000)
(define-key vterm-mode-map (kbd "C-S-v") #'vterm-yank))

(use-package vterm-toggle
  :ensure t
  :after vterm
  :config
  ;;(require 'project)
  ;;(setq vterm-toggle-project-root-function #'project-root)
  (setq vterm-toggle-fullscreen-p nil)
  (setq vterm-toggle-scope 'project)
  (add-to-list 'display-buffer-alist
               '((lambda (buffer-or-name _)
                     (let ((buffer (get-buffer buffer-or-name)))
                       (with-current-buffer buffer
                         (or (equal major-mode 'vterm-mode)
                             (string-prefix-p vterm-buffer-name (buffer-name buffer))))))
                  (display-buffer-reuse-window display-buffer-at-bottom)
                  ;;(display-buffer-reuse-window display-buffer-in-direction)
                  ;;display-buffer-in-direction/direction/dedicated is added in emacs27
                  ;;(direction . bottom)
                  ;;(dedicated . t) ;dedicated is supported in emacs27
                  (reusable-frames . visible)
                  (window-height . 0.3))))

(use-package sudo-edit
  :ensure t
  :config
  (dt/leader-keys
    "f" '(:ignore t :wk "Files")
    "f u" '(sudo-edit-find-file :wk "Sudo find file")
    "f U" '(sudo-edit :wk "Sudo edit file")))

(use-package doom-themes
  :ensure t
  :config
  (load-theme 'doom-one t))

(setq my/dark-theme 'doom-one)
(setq my/light-theme 'doom-opera-light)
(setq my/current-theme my/dark-theme)

(defun my/toggle-theme ()
  "Toggle between dark and light Doom themes."
  (interactive)
  (disable-theme my/current-theme)
  (setq my/current-theme
        (if (eq my/current-theme my/dark-theme)
            my/light-theme
          my/dark-theme))
  (load-theme my/current-theme t))

  ;; Link to make custom themes (https://mswift42.github.io/themecreator/)
  ;; Make !/.config/emacs/themes/dtmacs-theme.el
  ;;(add-to-list 'custom-theme-load-path "~/.config/emacs/themes/")
  ;;(load-theme 'dtmacs t)

(use-package tldr
 :ensure t)

(use-package which-key
  :ensure t
  :init
    (which-key-mode 1)
  :diminish
  :config
  (setq which-key-side-window-location 'bottom
        which-key-sort-order #'which-key-key-order-alpha
	which-key-sort-uppercase-first nil
	which-key-add-column-padding 1
	which-key-max-display-columns nil
	which-key-min-display-lines 6
	which-key-side-window-slot -10
	which-key-side-window-max-height 0.25
	which-key-idle-delay 0.8
	which-key-max-description-length 25
	which-key-allow-imprecise-window-fit nil
	which-key-separator " → " ))

;; Vim-like settings in Emacs
(setq display-line-numbers-type 'relative)

(defun my/toggle-line-numbers ()
  "Toggle between relative and absolute line numbers."
  (interactive)
  (setq display-line-numbers-type
        (if (eq display-line-numbers-type 'relative)
            'absolute
          'relative))
  (global-display-line-numbers-mode 1)) ;; Ensure it's on

(global-font-lock-mode 1)              ;; syntax on
(setq-default tab-width 4)             ;; tabstop
(setq-default standard-indent 4)       ;; shiftwidth
(setq-default c-basic-offset 4)        ;; for C/C++/Java
(setq-default indent-tabs-mode nil)    ;; expandtab
(electric-indent-mode 1)               ;; autoindent
(electric-pair-mode 1)                 ;; pair '(' with ')'

;; The following prevents <> from auto-pairing when electric-pair-mode is on.
;; Otherwise, org-tempo is broken when you try to <s TAB...
(add-hook 'org-mode-hook (lambda ()
           (setq-local electric-pair-inhibit-predicate
                   `(lambda (c)
                  (if (char-equal c ?<) t (,electric-pair-inhibit-predicate c))))))

(setq org-edit-src-content-indentation 0)
