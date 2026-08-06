;; Use a separate file for custom.el
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))

;; Theme and font
(load-theme 'modus-vivendi)
(set-face-attribute 'default nil :font "Iosevka 15")

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

(use-package emacs
  :custom
  (context-menu-mode t)
  (enable-recursive-minibuffers t)
  (read-extended-command-predicate #'command-completion-default-include-p)
  (minibuffer-prompt-properties
   '(read-only t cursor-intangible t face minibuffer-prompt)))

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
     tabs
     lines-tail
     empty
     indentation
     space-before-tab
     space-after-tab)))

;; Delete trailing whitespace before saving.
(add-hook 'before-save-hook #'delete-trailing-whitespace)

(use-package cider
  :ensure t)

(setq cider-lein-command "/opt/homebrew/bin/lein")

(use-package paredit
  :hook ((emacs-lisp-mode clojure-mode cider-repl-mode) . paredit-mode))

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
(use-package magit)

(use-package expand-region
  :bind
  ("C-=" . er/expand-region))

;; Delete selected items
(delete-selection-mode 1)

(use-package which-key
  :init
  (which-key-mode))
