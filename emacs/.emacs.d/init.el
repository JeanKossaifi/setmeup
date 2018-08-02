;; This file replaces itself with the actual configuration at first run.
;; Source: https://github.com/larstvei/dot-emacs/blob/master/init.el

;; Check whether we need to set the user-emacs directory here
;; e.g. https://github.com/cbrecabarren/user-emacs-directory/blob/master/init.el#L2

;; We can't tangle without org!
(require 'org)
;; Open the configuration
(find-file (concat user-emacs-directory "init.org"))
;; tangle it
(org-babel-tangle)
;; load it
(load-file (concat user-emacs-directory "init.el"))
;; finally byte-compile it
(byte-compile-file (concat user-emacs-directory "init.el"))
