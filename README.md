emacs-project-directory
=======================

Enhancement to the `compile' package allowing you to invoke M-x
compile from a deep subdirectory of the project directory, which is
the directory that contains, e.g., your Makefile.

## Instructions

1.  Add the following to your init file (usually ~/.emacs):

        (eval-after-load 'compile '(require 'project-directory))

    or if you want:

        (require 'project-directory)

2.  Copy project-directory.el to somewhere in your load-path.

