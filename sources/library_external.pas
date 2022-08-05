unit library_external;

interface

uses
{$IFDEF MSWINDOWS}
  Windows,
{$ENDIF MSWINDOWS}
  firebird_classes;

implementation

{$IFDEF MSWINDOWS}

procedure ThreadDetach(dllparam : NativeInt);
begin
  RLibraryHeapManager.ClearDependentFromParent(nil);
end;

procedure DLLMain(AReason: DWORD);
begin
  case AReason of
    // DLL_PROCESS_ATTACH:
    // DLL_THREAD_ATTACH:
    DLL_THREAD_DETACH:
      ThreadDetach(0);
    // DLL_PROCESS_DETACH:
  end
end;
{$ENDIF MSWINDOWS}

initialization

{$IFDEF MSWINDOWS}
  {$IFDEF FPC}
    DLL_THREAD_DETACH_Hook := @ThreadDetach;
  {$ELSE  FPC}
    DLLProc := @DLLMain;
  {$ENDIF FPC}
// DLLMain(DLL_PROCESS_ATTACH);
{$ENDIF MSWINDOWS}

end.
