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

;; Enable Vertico.
(use-package vertico
  :init
  (vertico-mode))

;; Persist history over Emacs restarts. Vertico sorts by history position.
(use-package savehist
  :init
  (savehist-mode))

;; Emacs minibuffer configurations.
(use-package emacs
  :custom
  ;; Enable context menu. `vertico-multiform-mode' adds a menu in the minibuffer
  ;; to switch display modes.
  (context-menu-mode t)
  ;; Support opening new minibuffers from inside existing minibuffers.
  (enable-recursive-minibuffers t)
  ;; Hide commands in M-x which do not work in the current mode.  Vertico
  ;; commands are hidden in normal buffers. This setting is useful beyond
  ;; Vertico.
  (read-extended-command-predicate #'command-completion-default-include-p)
  ;; Do not allow the cursor in the minibuffer prompt
  (minibuffer-prompt-properties
   '(read-only t cursor-intangible t face minibuffer-prompt)))

;; Optionally use the `orderless' completion style.
(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles partial-completion))))
  (completion-category-defaults nil)
  (completion-pcm-leading-wildcard t))


;; Enable rich annotations using the Marginalia package
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
