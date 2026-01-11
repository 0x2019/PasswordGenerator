unit uPassword;

interface

uses
  System.SysUtils, Winapi.Windows;

const
  BCRYPT_USE_SYSTEM_PREFERRED_RNG = $00000002;

  Digits            = '0123456789';
  LowerCase         = 'abcdefghijklmnopqrstuvwxyz';
  UpperCase         =  'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  SpecialChars      = '!@#$%^&*()_+|\=-<>.,/?'';:"][}{';

type
  NTSTATUS = LongInt;

  TPasswordCharGroup      = (pcgDigits, pcgLowercase, pcgUppercase, pcgSpecialChars);
  TPasswordCharGroupSet   = set of TPasswordCharGroup;

  TPasswordOptions = record
    Len: Integer;
    Groups: TPasswordCharGroupSet;
    RequireAllGroups: Boolean;
    SpecialCharSet: string;
  end;

function BCryptGenRandom(hAlgorithm: THandle; pbBuffer: PByte; cbBuffer: Cardinal; dwFlags: Cardinal): NTSTATUS; stdcall; external 'bcrypt.dll';
function GeneratePassword(const Opt: TPasswordOptions; out Password, ErrorMsg: string): Boolean;

implementation

uses
  uMain.UI.Messages;

var
  BCryptStatus: NTSTATUS = 0;

function SecureRandomBytes(Buffer: Pointer; Count: Cardinal): Boolean;
var
  Status: NTSTATUS;
begin
  Status := BCryptGenRandom(0, PByte(Buffer), Count, BCRYPT_USE_SYSTEM_PREFERRED_RNG);
  BCryptStatus := Status;
  Result := Status = 0;
end;

function SecureRandomUInt32(out Value: Cardinal): Boolean;
begin
  Result := SecureRandomBytes(@Value, SizeOf(Value));
end;

function SecureRandomIndex(MaxExclusive: Integer): Integer;
var
  v, limit: Cardinal;
begin
  if MaxExclusive <= 1 then Exit(0);

  limit := High(Cardinal) - (High(Cardinal) mod Cardinal(MaxExclusive));
  repeat
    if not SecureRandomUInt32(v) then
      raise Exception.CreateFmt('BCryptGenRandom failed (NTSTATUS=0x%.8x)', [Cardinal(BCryptStatus)]);
  until v < limit;

  Result := Integer(v mod Cardinal(MaxExclusive));
end;

procedure SwapChar(var A, B: Char);
var
  T: Char;
begin
  T := A; A := B; B := T;
end;

function BuildPool(const Opt: TPasswordOptions; out Parts: TArray<string>): string;
var
  Pool: string;
begin
  Pool := '';
  SetLength(Parts, 0);

  if pcgDigits in Opt.Groups then begin
    Parts := Parts + [Digits];
    Pool := Pool + Digits;
  end;
  if pcgLowercase in Opt.Groups then begin
    Parts := Parts + [LowerCase];
    Pool := Pool + LowerCase;
  end;
  if pcgUppercase in Opt.Groups then begin
    Parts := Parts + [UpperCase];
    Pool := Pool + UpperCase;
  end;
  if pcgSpecialChars in Opt.Groups then
  begin
    if Opt.SpecialCharSet = '' then
    begin
      Parts := Parts + [SpecialChars];
      Pool := Pool + SpecialChars;
    end
    else
    begin
      Parts := Parts + [Opt.SpecialCharSet];
      Pool := Pool + Opt.SpecialCharSet;
    end;
  end;

  Result := Pool;
end;

function GeneratePassword(const Opt: TPasswordOptions; out Password, ErrorMsg: string): Boolean;
var
  Parts: TArray<string>;
  Pool: string;
  GroupCount, i, L: Integer;
begin
  Password := '';
  ErrorMsg := '';
  Result := False;

  L := Opt.Len;
  if L <= 0 then
  begin
    ErrorMsg := SPwdLenTooSmallMsg;
    Exit;
  end;

  Pool := BuildPool(Opt, Parts);
  if Pool = '' then
  begin
    ErrorMsg := SPwdNoGroupSelectedMsg;
    Exit;
  end;

  GroupCount := Length(Parts);

  if Opt.RequireAllGroups and (L < GroupCount) then
  begin
    ErrorMsg := Format(SPwdLenTooSmallFmtMsg, [L, GroupCount]);
    Exit;
  end;

  try
    SetLength(Password, L);

    if Opt.RequireAllGroups then
    begin
      for i := 0 to GroupCount - 1 do
        Password[i + 1] := Parts[i][SecureRandomIndex(Length(Parts[i])) + 1];

      for i := GroupCount + 1 to L do
        Password[i] := Pool[SecureRandomIndex(Length(Pool)) + 1];

      for i := L downto 2 do
        SwapChar(Password[i], Password[SecureRandomIndex(i) + 1]);
    end
    else
    begin
      for i := 1 to L do
        Password[i] := Pool[SecureRandomIndex(Length(Pool)) + 1];
    end;

    Result := True;
  except
    on E: Exception do
    begin
      Password := '';
      ErrorMsg := E.Message;
      Result := False;
    end;
  end;
end;

end.
