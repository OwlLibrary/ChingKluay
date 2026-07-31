#define MyAppName "ChingKluay"
#define MyAppVersion "1.0.1"
#define MyAppPublisher "wingoflittleowl"
#define MyAppURL "https://www.youtube.com/@wingoflittleowl"
#define MyAppExeName "ChingKluay.vst3"

[Setup]
AppId={{525600C8-A956-4721-AF01-0A37088B7553}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={commoncf64}\VST3\
DisableDirPage=yes
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
DefaultGroupName={#MyAppName}
;License file
LicenseFile=[Add your license path here...]
PrivilegesRequiredOverridesAllowed=dialog
;This create a folder named {autodesktop} for some reason, idk
OutputDir={autodesktop}
OutputBaseFilename=ChingKluay Installer
SolidCompression=yes
WizardStyle=modern

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Files]
; 1. Install the VST3 plugin
Source: "[Add your HISE project path here...]\ChingKluay\Binaries\Compiled\VST3\{#MyAppExeName}"; DestDir: "{commoncf64}\VST3"; Flags: ignoreversion

; 2. Install the sound library
; Current structure: has 3 .ch1 files inside
Source: "[Add your sample folder path here...]\*"; DestDir: "{code:GetSoundLibDir}"; Flags: ignoreversion recursesubdirs createallsubdirs

; 3. Install the library locator
; Current structure: [Add your folder path here...]\wingoflittleowl\ChingKluay
Source: "[Add your folder path here...]\*"; DestDir: "{userappdata}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{group}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}"

[Code]
var
  SoundLibPage: TInputDirWizardPage;

// Custom procedure to force the newer browse dialog with the "Make New Folder" button
procedure SoundLibBrowseButtonClick(Sender: TObject);
var
  Dir: String;
begin
  // Grab the current path from the text box
  Dir := SoundLibPage.Values[0];
  
  // Open the Browse For Folder dialog with the "Make New Folder" button enabled (True)
  if BrowseForFolder('Select Sound Library Location', Dir, True) then
  begin
    // If the user selects a folder and clicks OK, update the text box
    SoundLibPage.Values[0] := Dir;
  end;
end;

procedure InitializeWizard;
begin
  // Create the custom directory page AFTER the License Page (wpLicense)
  SoundLibPage := CreateInputDirPage(wpLicense,
    'Select Sound Library Location', 
    'Where should the sound library files be installed?',
    'Select the folder in which Setup should install the {#MyAppName} sound library, then click Next.',
    False, '');
  
  // Add a directory input item to the page
  SoundLibPage.Add('');
  
  // Set a default value (Public Documents)
  SoundLibPage.Values[0] := ExpandConstant('{commondocs}\wingoflittleowl\ChingKluay Library');
  
  // Override the default Browse button to use our custom function
  SoundLibPage.Buttons[0].OnClick := @SoundLibBrowseButtonClick;
end;

// This function allows the [Files] section to access the path the user selected
function GetSoundLibDir(Param: String): String;
begin
  Result := SoundLibPage.Values[0];
end;

// This runs after files are copied. It creates and injects the path into the LinkWindows file.
procedure CurStepChanged(CurStep: TSetupStep);
var
  LinkFilePath: String;
  SelectedLibPath: String;
begin
  // ssPostInstall means "after all files have been copied to the computer"
  if CurStep = ssPostInstall then
  begin
    // Define where the LinkWindows file needs to go
    LinkFilePath := ExpandConstant('{userappdata}\wingoflittleowl\ChingKluay\LinkWindows');
    
    // Grab the path the user selected in the custom wizard page
    SelectedLibPath := GetSoundLibDir('');
    
    // Write the path directly into the LinkWindows file
    SaveStringToFile(LinkFilePath, SelectedLibPath, False);
  end;
end;