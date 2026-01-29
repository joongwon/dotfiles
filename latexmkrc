if ($^O eq 'linux') {
  $quote_filenames = 0; # Quoting is omitted, especially for pdf_previewer command
  $pdf_previewer = "xpdf -remote %R 'openFile(%S)'";
  $pdf_update_method = 4; # Run a command to do the update
  $pdf_update_command = "xpdf -remote %R reload";
}
