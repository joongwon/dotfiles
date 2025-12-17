if ($^O eq 'linux') {
  $quote_filenames = 0;
  $pdf_previewer = "xpdf -remote %R 'openFile(%S)'";
  $pdf_update_method = 4;
  $pdf_update_command = "xpdf -remote %R reload";
}
