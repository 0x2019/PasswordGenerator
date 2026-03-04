unit uMenu;

interface

uses
  Winapi.Windows, Vcl.Menus;

procedure UI_Menu_UpdateClipboard(AMenuItem: TMenuItem);

implementation

procedure UI_Menu_UpdateClipboard(AMenuItem: TMenuItem);
begin
  if Assigned(AMenuItem) then
    AMenuItem.Enabled := IsClipboardFormatAvailable(CF_UNICODETEXT) or
                                   IsClipboardFormatAvailable(CF_TEXT) or
                                   IsClipboardFormatAvailable(CF_BITMAP) or
                                   IsClipboardFormatAvailable(CF_DIB) or
                                   IsClipboardFormatAvailable(CF_HDROP);
end;

end.
