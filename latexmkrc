if ($^O eq 'linux') {
  $quote_filenames = 0; # Quoting is omitted, especially for pdf_previewer command
  if (system("command -v zathura >/dev/null 2>&1") == 0) {
    $pdf_previewer = "zathura --fork '%S'";
    $pdf_update_method = 0;
  } else {
    $pdf_previewer = "xpdf -remote %R 'openFile(%S)'";
    $pdf_update_method = 4;
    $pdf_update_command = "xpdf -remote %R reload";
  }
}
