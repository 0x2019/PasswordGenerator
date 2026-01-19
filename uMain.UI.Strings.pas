unit uMain.UI.Strings;

interface

resourcestring
  APP_NAME                            = 'Password Generator';
  APP_VERSION                         = 'v1.0.0.0';
  APP_RELEASE                         = 'January 11, 2026';
  APP_URL                             = 'https://github.com/0x2019/PasswordGenerator';

  SFileSavedMsg                       = 'File successfully saved!' + sLineBreak + 'Path: %s';
  SFileSaveErrMsg                     = 'Failed to save the file.' + sLineBreak + 'Path: %s' + sLineBreak + '%s';

  SOpenFileMsg                        = 'Would you like to open the file now?';
  SOpenFileFailMsg                    = 'Failed to open the file.';

  SPwdLenTooSmallMsg                  = 'Length must be greater than 0.';
  SPwdLenTooSmallFmtMsg               = 'Length (%d) is too small for selected groups (%d).';
  SPwdNoGroupSelectedMsg              = 'No character group selected.';

  SClipboardClearErrMsg               = 'Unable to clear the clipboard.' + sLineBreak + '%s';
  SClipboardCopyErrMsg                = 'Unable to copy to the clipboard.' + sLineBreak + '%s';

  SAboutMsg                           = '%s %s' + sLineBreak +
                                        'c0ded by 龍, written in Delphi.' + sLineBreak + sLineBreak +
                                        'Release Date: %s' + sLineBreak +
                                        'URL: %s';

implementation

end.
