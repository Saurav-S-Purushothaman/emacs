
;; Use a separate file for custom.el
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))

;; Theme and font

;; custom theme path
(add-to-list 'custom-theme-load-path "~/themes")
(load-theme 'ef-arcadia)
(set-face-attribute 'default nil :font "liberation mono 14")
;;  (set-frame-font "reddit Mono 13")
;;  (set-frame-font "red hat mono")
;;  (set-frame-font "Intel one mono 13")

;; (setq-default line-spacing 0)

;; Adding melpa
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/")
             t)
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

(require 'use-package)
(setq use-package-always-ensure t)

(use-package vertico
  :init
  (vertico-mode))

;; Persist history over Emacs restarts. Vertico sorts by history position.
(use-package savehist
  :init
  (savehist-mode))

;; Remember recently opened files across Emacs restarts.
(use-package recentf
  :ensure nil
  :custom
  (recentf-max-saved-items 200)
  (recentf-max-menu-items 25)
  :init
  (recentf-mode))

;; Include recent files when switching with C-x b.
(use-package consult
  :bind
  ("C-x b" . consult-buffer)
  ("C-x C-r" . consult-recent-file))

;; Keep generated/cache directories out of project file completion.
(use-package project
  :ensure nil
  :custom
  (project-vc-ignores
   '(".clj-kondo/"
     ".lsp/"
     ".cpcache/"
     "target/"
     "node_modules/")))

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles partial-completion))))
  (completion-category-defaults nil)
  (completion-pcm-leading-wildcard t))

(use-package marginalia
  :bind (:map minibuffer-local-map
        ("M-A" . marginalia-cycle))
  :init
  (marginalia-mode))

;; Show unwanted whitespace in programming and text buffers.
(use-package whitespace
  :ensure nil
  :hook ((prog-mode text-mode conf-mode) . whitespace-mode)
  :custom
  (whitespace-line-column 100)
  (whitespace-style
   '(face
     trailing
     ;; lines-tail
     empty
     ;; indentation
     space-before-tab
     space-after-tab)))

;; Delete trailing whitespace before saving.
(add-hook 'before-save-hook #'delete-trailing-whitespace)

(use-package cider
  :ensure t
  :hook (clojure-mode . cider-mode))

;; (setq cider-lein-command "/opt/homebrew/bin/lein")

(use-package paredit
  :hook ((emacs-lisp-mode clojure-mode) . paredit-mode))

(use-package ultra-scroll
  :init
  (setq scroll-conservatively 3
        scroll-margin 0)
  :config
  (ultra-scroll-mode 1))

;; Enable global auto-save to the actual file
(auto-save-visited-mode 1)
(setq auto-save-visited-interval 5)

(use-package project
  :ensure nil
  :custom
  (project-vc-ignores
   '(".clj-kondo/"
     ".lsp/"
     ".cpcache/"
     "target/"
     "node_modules/")))


(use-package clojure-mode)

(use-package with-editor
  :custom
  (with-editor-emacsclient-executable "/opt/homebrew/opt/emacs-plus@30/bin/emacsclient"))

(use-package magit)

(use-package expand-region
  :bind
  ("C-=" . er/expand-region))

;; Delete selected items
(delete-selection-mode 1)

(use-package which-key
  :init
  (which-key-mode))

(use-package markdown-mode
  :ensure t
  :mode ("README\\.md\\'" . gfm-mode)
  :init (setq markdown-command "multimarkdown")
  :bind (:map markdown-mode-map
         ("C-c C-e" . markdown-do)))

(use-package undo-tree)
(global-undo-tree-mode)
(setq undo-limit 150)

(use-package corfu
  :custom
  (corfu-auto t)
  (corfu-auto-prefix 1)
  (corfu-auto-delay 0.2)
  (corfu-cycle t)
  (corfu-preview-current nil)
  :init
  (global-corfu-mode))

;; Extra completion-at-point backends. Major-mode completions still run first;
;; these provide useful fallbacks for files, words, and symbols.
(use-package cape
  :init
  (add-to-list 'completion-at-point-functions #'cape-file t)
  (add-to-list 'completion-at-point-functions #'cape-dabbrev t)
  (add-to-list 'completion-at-point-functions #'cape-keyword t))

(use-package emacs
  :custom
  (tab-always-indent 'complete)
  (text-mode-ispell-word-completion nil)
  (read-extended-command-predicate #'command-completion-default-include-p)
  (context-menu-mode t)
  (enable-recursive-minibuffers t)
  (read-extended-command-predicate #'command-completion-default-include-p)
  (minibuffer-prompt-properties
   '(read-only t cursor-intangible t face minibuffer-prompt)))

(add-hook 'eshell-mode-hook (lambda ()
                            (setq-local corfu-auto nil)
                              (corfu-mode)))

(use-package indent-bars
  :hook ((python-mode yaml-mode) . indent-bars-mode))


(use-package golden-ratio)
;; (require 'golden-ratio)
;; (golden-ratio-mode 1)

(use-package idle-highlight-mode)
(global-idle-highlight-mode t)

(use-package move-text
  :bind (("C-S-<up>" . move-text-up)
         ("C-S-<down>" . move-text-down)))

(use-package crux
  :bind ("s-j" . crux-top-join-line))

(use-package mwim
  :ensure t
  :bind (("C-a" . mwim-beginning-of-code-or-line)
         ("C-e" . mwim-end-of-code-or-line)))

(scroll-bar-mode -1)

(use-package multiple-cursors)
(require 'multiple-cursors)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-,") 'duplicate-line)

;; (use-package rainbow-delimiters)
;; (add-hook 'clojure-mode-hook #'rainbow-delimiters-mode)
;; (add-hook 'emacs-lisp-mode-hook #'rainbow-delimiters-mode)

;; Remove toolbar
(tool-bar-mode -1)

;; Clojure lsp
(add-hook 'clojure-mode-hook 'lsp)

;; Step through the references of the symbol at point, one at a time.
;; M-n / M-p move forward / back (wrapping around); M-, returns to where
;; you started. Calling it anywhere other than the current reference
;; re-fetches references for the symbol under point.
(defvar my/lsp-refs nil "Vector of (FILE . POSITION) for the current walk.")
(defvar my/lsp-refs-index 0 "Index into `my/lsp-refs' of the current reference.")

(defun my/lsp-refs--at-current-p ()
  "Non-nil when point is on the reference we last jumped to."
  (when (and my/lsp-refs buffer-file-name)
    (let ((ref (aref my/lsp-refs my/lsp-refs-index)))
      (and (file-equal-p (car ref) buffer-file-name)
           (= (point) (lsp--position-to-point (cdr ref)))))))

(defun my/lsp-refs--fetch ()
  "Ask the server for references to the symbol at point, excluding its def."
  (let* ((locs (lsp-request
                "textDocument/references"
                (append (lsp--text-document-position-params)
                        (list :context (list :includeDeclaration :json-false)))))
         (refs (mapcar (lambda (loc)
                         (cons (lsp--uri-to-path (lsp:location-uri loc))
                               (lsp:range-start (lsp:location-range loc))))
                       locs)))
    ;; Stable order: by file, then line, then column.
    (vconcat
     (sort refs
           (lambda (a b)
             (let ((la (lsp:position-line (cdr a)))
                   (lb (lsp:position-line (cdr b))))
               (cond ((not (string= (car a) (car b))) (string< (car a) (car b)))
                     ((/= la lb) (< la lb))
                     (t (< (lsp:position-character (cdr a))
                           (lsp:position-character (cdr b)))))))))))

(defun my/lsp-refs--step (delta)
  "Jump DELTA references from the current one, fetching them if needed."
  (if (my/lsp-refs--at-current-p)
      (setq my/lsp-refs-index
            (mod (+ my/lsp-refs-index delta) (length my/lsp-refs)))
    (let ((refs (my/lsp-refs--fetch)))
      (when (zerop (length refs))
        (user-error "No references found"))
      (xref-push-marker-stack)          ; so M-, comes back here
      (setq my/lsp-refs refs
            my/lsp-refs-index (if (< delta 0) (1- (length refs)) 0))))
  (let ((ref (aref my/lsp-refs my/lsp-refs-index)))
    (find-file (car ref))
    (goto-char (lsp--position-to-point (cdr ref)))
    (when (fboundp 'pulsar-pulse-line) (pulsar-pulse-line))
    (message "Reference %d/%d  %s:%d"
             (1+ my/lsp-refs-index) (length my/lsp-refs)
             (file-relative-name (car ref) (or (lsp-workspace-root) default-directory))
             (1+ (lsp:position-line (cdr ref))))))

(defun my/lsp-next-reference ()
  "Jump to the next reference of the symbol at point."
  (interactive)
  (my/lsp-refs--step 1))

(defun my/lsp-previous-reference ()
  "Jump to the previous reference of the symbol at point."
  (interactive)
  (my/lsp-refs--step -1))

(with-eval-after-load 'lsp-mode
  (define-key lsp-mode-map (kbd "M-n") #'my/lsp-next-reference)
  (define-key lsp-mode-map (kbd "M-p") #'my/lsp-previous-reference))

;; LSP-first: once a REPL is connected, CIDER's xref (M-. / M-?), completion
;; and eldoc hooks take priority over lsp-mode's. While this mode is on, those
;; CIDER hooks are removed so clojure-lsp serves them; CIDER eval/REPL commands
;; are unaffected. Toggle with C-c L.
(defun my/lsp-first--apply ()
  "Add or remove CIDER's navigation hooks in this buffer per `my/lsp-first-mode'."
  (when (bound-and-true-p cider-mode)
    (if (bound-and-true-p my/lsp-first-mode)
        (progn
          (remove-hook 'xref-backend-functions #'cider--xref-backend t)
          (remove-hook 'completion-at-point-functions #'cider-complete-at-point t)
          (remove-hook 'eldoc-documentation-functions #'cider-eldoc t))
      (when cider-use-xref
        (add-hook 'xref-backend-functions #'cider--xref-backend cider-xref-fn-depth t))
      (add-hook 'completion-at-point-functions #'cider-complete-at-point nil t)
      (add-hook 'eldoc-documentation-functions #'cider-eldoc nil t))))

(define-minor-mode my/lsp-first-mode
  "Let clojure-lsp, not CIDER, handle xref, completion and eldoc."
  :global t
  :init-value t
  (dolist (buf (buffer-list))
    (with-current-buffer buf (my/lsp-first--apply)))
  (message "Clojure navigation/completion: %s"
           (if my/lsp-first-mode "LSP" "CIDER")))

;; Re-apply whenever cider-mode turns on in a buffer (runs after its setup).
(add-hook 'cider-mode-hook #'my/lsp-first--apply)
(global-set-key (kbd "C-c L") #'my/lsp-first-mode)

(setq gc-cons-threshold (* 256 1024 1024) ; 256 MB
      read-process-output-max (* 4 1024 1024) ; 4 MB

      treemacs-space-between-root-nodes nil

      ;; company-minimum-prefix-length 1

      ;; Let LSP handle indentation/completion.
      ;; Uncomment these only if you're using CIDER for them instead.
      ;; lsp-enable-indentation nil
      ;; lsp-enable-completion-at-point nil
      )

;; Fix macos fullscreen issue
(when (eq system-type 'darwin)
  (setq frame-resize-pixelwise t)
  (setq ns-use-native-fullscreen nil))

;; Make global line number
(global-display-line-numbers-mode 1)

;; Add a custom theme path.

(setq ring-bell-function #'ignore)


;; Pulsar. Cursor should pulse when moving
(use-package pulsar
  :ensure t
  :config
  (pulsar-global-mode 1))

(load (expand-file-name "~/.quicklisp/slime-helper.el"))
(setq inferior-lisp-program "sbcl")
