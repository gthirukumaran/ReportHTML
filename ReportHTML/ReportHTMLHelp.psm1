
#Region Help Documentation
#FYI, This is mostly a terrible example of how to write a report. But if you must look under the covers, enjoy.

Write-Warning "Need a little help getting started?  Get-HTMLReportHelp"

Function Get-HTMLReportHelp {
	Param (
	    [switch]$GenerateReport
	)

#Region Housekeeping


	if([String]::IsNullOrEmpty($ModulePath))
	{
	    if([string]::IsNullOrEmpty($PSScriptRoot))
	    {
	        $ModulePath=$PSCmdlet.SessionState.Path.CurrentLocation.Path
	    }
	    else
	    {
	        $ModulePath = $PSScriptRoot 
        } 
    }

$process = Get-Process | select Name,Id,PriorityClass,Handles,FileVersion,WorkingSet,PrivateMemorySize, PagedMemorySize 


if ($GenerateReport) {
	$tabarray = @('Welcome','Reports','Logos','Styles','Options','Tabs','Sections','Columns','Tables','Row Colour','HyperLinks','Charts','JavaScript','HTML','Functions')
	$rpt = @()
	$rpt += Get-HTMLOpenPage -TitleText ("ReportHTML " + (get-Module -Name reporthtml).version + ", Cmdlets Usage, Help & Examples") -LeftLogoName Corporate -RightLogoName Alternate
	$rpt += Get-HTMLTabHeader -TabNames $tabarray 
#endregion

#region Welcome
      $Tab = 'Welcome'
      $rpt += get-htmltabcontentopen -TabName $Tab -tabheading ' '
            $rpt += Get-HTMLContentOpen -HeaderText "About" 
				$rpt += Get-HTMLContentText -Heading "Why we wrote this" -Detail "PowerShell is an amazing tool for gathering, collecting, slicing, grouping, filtering and collating data.  However, trying to show that information or several sets of it on one report is not as easy.  A few years we ago built our own solution, we created a set of HTML reporting functions.  I have been using these functions for years to help myself, my team and customers to deliver Powershell data to people that just need the details and not a CSV file or a code snippet. We’ve now decided to make these available to the rest of you."
                $rpt += Get-HTMLContentText -Heading "Original Credits" -detail "This code was originally borrowed from Alan Renouf for a vSphere healthcheck report by Andrew Storrs and myself for a more dynamic reporting style, being able to create reports on the fly with minimal effort. "
				$rpt += Get-HTMLContentText -Heading "Recent Credits" -Detail "Jennifier Han, Giovanni Fleres, Chris Speers, Keith Ellis, Blake and Moep"
				$rpt += Get-HTMLContentText -Heading "Running Reports" -Detail "These reports, once built can be scheduled to run, dropped on a file share emailed or saved to an Azure Storage Blob. "
				$rpt += Get-HTMLContentText -Heading "This Help Report" -Detail "Will walk through several examples of how to use the functions to generate different types of reports."
				$rpt += Get-HTMLContentText -Heading "Beta Help File" -Detail ("Please note this help is in a first draft")
			$rpt += Get-HTMLContentClose
			$rpt += Get-HTMLContentOpen -HeaderText  'Something missing? Got an idea? Found a bug? Contribute'
                  $rpt += Get-HTMLContentText -Heading "PowerShell Gallery" -Detail "URL01https://www.powershellgallery.com/packages/ReportHTML/URL02Add A Comment on powershell galleryURL03"
                  $rpt += Get-HTMLContentText -Heading "Github" -Detail "URL01https://www.github.com/azurefieldnotes/ReportHTML/URL02Write some code, branch it, merge it, Join me and lets hack and slash together.URL03"
				  $rpt += Get-HTMLContentText -Heading "Log Issue" -Detail "URL01https://github.com/azurefieldnotes/ReportHTML/URL02Log an IssueURL03"
            $rpt += Get-HTMLContentClose

      $rpt += get-htmltabcontentclose
#endregion

#region Reports Tab
$BuildingRpt = @'
$rpt = @()
$rpt += Get-HTMLOpenPage -TitleText "ReportHTML" 
	$rpt += Get-HTMLContentOpen 
		$rpt += Get-HTMLContentText -Heading "Header" -Detail "Detailed Information" 
	$rpt += Get-HTMLContentClose 
$rpt += Get-HTMLClosePage 
'@

$SavingRpt1 =@'
$rpt | set-content -path "c:\temp\MyReport.html"  
Set-Content -Value $rpt -path "c:\temp\MyReport.html"  
Invoke-item "c:\temp\MyReport.html"
'@

$SavingRpt2 =@'
Save-HTMLReport -Reportcontent $rpt -ReportPath c:\temp -ReportName "MyReport" -showreport
Save-HTMLReport -Reportcontent $rpt -ReportPath c:\temp -ReportName "MyReport.html" 
Save-HTMLReport -Reportcontent $rpt -ReportPath c:\temp -ReportName "MyReport" 
Save-HTMLReport -ShowReport 
$SavedFile = Save-HTMLReport -ShowReport 
'@

$SavingRpt3 =@'
Save-HTMLToBlobStorage -Needs an Azure Account #More to come
'@

$BuildingOutput = @() 
$BuildingOutput += Get-HTMLOpenPage -TitleText "ReportHTML" 
$BuildingOutput += Get-HTMLContentOpen 
$BuildingOutput += Get-HTMLContentText -Heading "Header" -Detail "Detailed Information" 
$BuildingOutput += Get-HTMLContentClose 
$BuildingOutput += Get-HTMLClosePage 

      # 'Reports'
      $Tab = 'Reports'
      $rpt += get-htmltabcontentopen -TabName $Tab -tabheading ' '
            $rpt += Get-HTMLContentOpen -HeaderText "Building Reports" -BackgroundShade 2
                  $rpt += Get-HTMLContentOpen -HeaderText "How this fucntion set works" 
                        $rpt += Get-HTMLContentText -Heading "Functions" -Detail "Each function return HTML code, the parameters you send in will be return with HTML code.  "
                        $rpt += Get-HTMLContentText -Heading "Building an Array" -Detail 'To build a report create an array object and add parts of your report together. <br> Eg, create an array variable $Rpt = @() <br>  Next add to the array. <BR> $RPT += get-htmlpageopen -title "Welcome"'
                        $rpt += Get-HTMLContentText -Heading "Open / Close" -Detail "Although these functions help you with HTML its still HTML.  HTML uses tags and everything you open you must close <BR> Get-HTMLContentOpen -HeaderText, creates a section header.  You can then add other functions and code.  However you must eventually add get-HTMLContentClose.  <BR>  Using Indenting is an easy way to keep track of what tag your in."
                        $rpt += Get-HTMLContentText -Heading "Saving Reports" -Detail 'The Array need to be saved to a file, there are a couple of options for this. <BR>  You can save the array to a file using set-content.  <BR>  $rpt | set-content -path "c:\temp\MyReport.html" <BR> You can use the Save-HTMLReport Function.  There is also a save to storage azure blob option'
                  $rpt += Get-HTMLContentClose  
                  $rpt += Get-HTMLContentOpen -HeaderText "Example" 
                        $rpt += Get-HTMLContentText -Heading "Building Report Code" -Detail (Get-HTMLCodeBlock -Code $BuildingRpt -Style PowerShell)
						$rpt += Get-HTMLContentText -Heading "Saving a Report - Write Array to file" -Detail (Get-HTMLCodeBlock -Code $SavingRpt1 -Style PowerShell)
						$rpt += Get-HTMLContentText -Heading "Saving a Report - Use the builtin function (1 Liner Options)" -Detail (Get-HTMLCodeBlock -Code $SavingRpt2 -Style PowerShell)
						$rpt += Get-HTMLContentText -Heading "Saving a Report - Save To Azure Storage Blob" -Detail (Get-HTMLCodeBlock -Code $SavingRpt3 -Style PowerShell)
                  $rpt += Get-HTMLContentClose  
                  $rpt += Get-HTMLContentOpen -HeaderText "Report Output" 
                        $rpt += $BuildingOutput
                  $rpt += Get-HTMLContentClose  

            $rpt += Get-HTMLContentClose  
      $rpt += Get-HTMLTabContentClose
#endregion

#region Logos
      # 'Loading Logos'
      $Tab = 'Logos'
      $rpt += get-htmltabcontentopen -TabName $Tab -tabheading ' '
      
#endregion

#region Logo names
            $rpt += Get-HTMLContentOpen -HeaderText "Adding logos to the header" -BackgroundShade 3
                  $rpt += Get-HTMLContentOpen -HeaderText "Parameters" 
                        $rpt += Get-HTMLContentText -Heading "Mixed and Match" -Detail "You can use the following parameters in a mix and match format"
						$rpt += Get-HTMLContentText -Heading "-LeftLogoName" -Detail "These switch will load logos to the top left of the report from JPG files saved in the module directory.  There are 4 image files in the module for examples 'Alternate','Blank','Sample' and 'Corporate' (this uses Get-HTMLLogos)"
                        $rpt += Get-HTMLContentText -Heading "-RightLogoName" -Detail "These switch will load logos to the top of the report right from JPG files saved in the module directory.  There are 4 image files in the module for examples 'Alternate','Blank','Sample' and 'Corporate' (this uses Get-HTMLLogos)"
						$rpt += Get-HTMLContentText -Heading "-LeftLogoString" -Detail "You can eith use a URL reference here, or Base 64 encoded string"
                        $rpt += Get-HTMLContentText -Heading "-RightLogoString" -Detail "You can eith use a URL reference here, or Base 64 encoded string"
						$rpt += Get-HTMLContentText -Heading "-hidelogos" -Detail "Remove the header"
						$rpt += Get-HTMLContentText -Heading "-LogoPath" -Detail "Use in conjunction with LeftLogoName and RightLogo Name. Specify the File Name in the directory"
                  $rpt += Get-HTMLContentClose  
					#### From examples
                  $rpt += Get-HTMLContentOpen -HeaderText "From Image Examples"  -BackgroundShade 2 
                        $rpt += Get-HTMLContentOpen -HeaderText "Exmaple 1"  -BackgroundShade 1
                              $rpt += Get-HTMLContentOpen -HeaderText "Code"
                                    $rpt += Get-HTMLContentText -Heading "Load Images from Files" -Detail (get-htmlcodeblock  -Style PowerShell -Code 'Get-HTMLOpenPage -TitleText "Example 1" -LeftLogoName Corporate -RightLogoName Alternate')
                              $rpt += Get-HTMLContentClose  
                              $rpt += Get-HTMLContentOpen -HeaderText "Output"
                                    $rpt += Get-HTMLOpenPage -TitleText "Example 1" -LeftLogoName Corporate -RightLogoName Alternate
                              $rpt += Get-HTMLContentClose  
                        $rpt += Get-HTMLContentClose  

                        $rpt += Get-HTMLContentOpen -HeaderText "Exmaple 2" -BackgroundShade 1
                              $rpt += Get-HTMLContentOpen -HeaderText "Code"
                                    $rpt += Get-HTMLContentText -Heading "Load Images from Files" -Detail (get-htmlcodeblock  -Style PowerShell -Code 'Get-HTMLOpenPage -TitleText "Example 2" -LeftLogoName Blank -RightLogoName Sample')
                              $rpt += Get-HTMLContentClose  
                              $rpt += Get-HTMLContentOpen -HeaderText "Output"
                                    $rpt += Get-HTMLOpenPage -TitleText "Example 2" -LeftLogoName Blank -RightLogoName Sample
                              $rpt += Get-HTMLContentClose  
                        $rpt += Get-HTMLContentClose
                  $rpt += Get-HTMLContentClose
#            		####URL Examples
                  $rpt += Get-HTMLContentOpen -HeaderText "Logo String Examples (URL and Base64)"  -BackgroundShade 2 
                        $rpt += Get-HTMLContentOpen -HeaderText "Exmaple 3"  -BackgroundShade 1
                              $rpt += Get-HTMLContentOpen -HeaderText "Code"
                                    $rpt += Get-HTMLContentText -Heading "Load Images from a URL" -Detail (get-htmlcodeblock  -Style PowerShell -Code 'Get-HTMLOpenPage -TitleText "Example 1" -LeftLogoString "https://azurefieldnotesblog.blob.core.windows.net/wp-content/2016/07/powershell.jpg" ` <BR> -RightLogoString "https://azurefieldnotesblog.blob.core.windows.net/wp-content/2016/07/datacenter.jpg"')
                              $rpt += Get-HTMLContentClose  
                              $rpt += Get-HTMLContentOpen -HeaderText "Output"
                                    $rpt += Get-HTMLOpenPage -TitleText "Example 3" -LeftLogoString "https://azurefieldnotesblog.blob.core.windows.net/wp-content/2016/07/powershell.jpg" -RightLogoString "https://azurefieldnotesblog.blob.core.windows.net/wp-content/2016/07/datacenter.jpg"
                              $rpt += Get-HTMLContentClose  
                        $rpt += Get-HTMLContentClose  

                        $rpt += Get-HTMLContentOpen -HeaderText "Exmaple 4" -BackgroundShade 1
                              $rpt += Get-HTMLContentOpen -HeaderText "Code"
                                    $rpt += Get-HTMLContentText -Heading "Use Base 64 code" -Detail (get-htmlcodeblock  -Style PowerShell -Code '$OurLogos = Get-HTMLLogos <BR>$YourLogos = get-htmlLogos -LogoPath c:\YourPath\ <br>$Base64Logo = $OurLogos.get_item("Corporate") <BR>Get-HTMLOpenPage -TitleText "Example 2" -LeftLogoName Blank -RightLogoString $Base64Logo' )
                              $rpt += Get-HTMLContentClose  
                              $rpt += Get-HTMLContentOpen -HeaderText "Output"
                                    $OurLogos = Get-HTMLLogos 
									$Base64Logo = $OurLogos.get_item("Corporate") 
									$rpt += Get-HTMLOpenPage -TitleText "Example 4" -LeftLogoName Blank -RightLogoString $Base64Logo
                              $rpt += Get-HTMLContentClose  
                        $rpt += Get-HTMLContentClose
                  $rpt += Get-HTMLContentClose
			
				### Other
				
				  $rpt += Get-HTMLContentOpen -HeaderText "Logo String Examples (URL and Base64)"  -BackgroundShade 2 
                        $rpt += Get-HTMLContentOpen -HeaderText "Exmaple 5"  -BackgroundShade 1
                              $rpt += Get-HTMLContentOpen -HeaderText "Code"
                                    $rpt += Get-HTMLContentText -Heading "We dont need no stinking logos!" -Detail (get-htmlcodeblock  -Style PowerShell -Code 'Get-HTMLOpenPage -TitleText "Example 5" -HideLogos')
                                    $rpt += Get-HTMLContentText -Heading "Use a Logo Path" -Detail (get-htmlcodeblock  -Style PowerShell -Code 'Get-HTMLOpenPage -LogoPath "C:\path\" -LeftLogoName "NameOfFileInPath" -RightLogoName Blank' )
                        		$rpt += Get-HTMLContentClose
						$rpt += Get-HTMLContentClose
                  $rpt += Get-HTMLContentClose
      		$rpt += Get-HTMLContentClose
      $rpt += get-htmltabcontentclose
#Endregion

#region Styles
$CodeBlock =@'
$rpt += Get-HTMLOpenPage -CSSName Sample
$rpt += Get-HTMLContentOpen "Orange"
$rpt += Get-HTMLContentText -Heading "Sample Style" -Detail "whooo, coool."
$rpt += Get-HTMLContentClose
$rpt += Get-HTMLClosePage
Save-HTMLReport -ReportContent $rpt -ShowReport
'@

$Samplerpt =@()
$Samplerpt += Get-HTMLOpenPage -CSSName Sample
$Samplerpt += Get-HTMLContentOpen "Orange"
$Samplerpt += Get-HTMLContentText -Heading "Sample Style" -Detail "whooo, coool."
$Samplerpt += Get-HTMLContentClose 
$Samplerpt += Get-HTMLClosePage

	  
	  $Tab = 'Styles'
      $rpt += get-htmltabcontentopen -TabName $Tab -tabheading ' '
            $rpt += Get-HTMLContentOpen -HeaderText $Tab 
				$rpt += Get-HTMLContentOpen "Custom Style"
                  $rpt += Get-HTMLContentText -Heading "Customzie the Look" -detail "All style is in a CSS file so if you want to change it, you can"
				  $rpt += Get-HTMLContentText -Heading "Sample Style" -detail "This is just an example when you use get-htmlopenpage use the CSSName switch<BR>use the name of the css style sheet in the directory"
				  $rpt += Get-HTMLContentText -Heading "Usage" -detail "Style Sheets are best best used in conjuction with New-HTMLReportOptions from a custom local directory"
				  $rpt += Get-HTMLContentText -Heading "Code" -Detail (get-htmlcodeblock -style powershell -code $CodeBlock)
            	$rpt += Get-HTMLContentClose
			$rpt += Get-HTMLContentClose
      $rpt += get-htmltabcontentclose
#endregion

#region Options

$OptionCode =@'
$MyPath  ='C:\temp\Custom'
if ((Test-Path $MyPath ) -eq $false) {New-Item -ItemType	Directory -Path $mypath}
New-HTMLReportOptions -SaveOptionsPath $MyPath 
$Options = new-HTMLReportOptions -CSSPath c:\temp\ -cssname sample -ColorSchemePath c:\temp\ -LogoPath c:\temp\
$Rpt = @()
$Rpt += get-htmlopenpage -TitleText "External Options" -Options $Options
$Rpt += Get-HTMLContentOpen
$Rpt += Get-HTMLContenttext -Heading "this is custom" -Detail "nice"
$Rpt += Get-HTMLContentClose
$Rpt += Get-HTMLClosePage
Save-HTMLReport -ReportContent $rpt -ShowReport
'@
      $Tab = 'Options'
      $rpt += get-htmltabcontentopen -TabName $Tab -tabheading ' '
            $rpt += Get-HTMLContentOpen -HeaderText $Tab 
                  $rpt += Get-HTMLContentText -Heading "Creating Options" -detail "You can saver the options from the Module directory locally and modify them.<BR> for instance your logo files, css styles and even graph colour schemes"
				  $rpt += Get-HTMLContentText -Heading "Code" -Detail (get-htmlcodeblock -style powershell -code $OptionCode)
            $rpt += Get-HTMLContentClose
			
      $rpt += get-htmltabcontentclose
#endregion

#region Tabs
                        
$TabCode = @'
$tabarray = @('Sample1','Sample2','Sample3','Sample4')
$rpt = @()
$rpt += Get-HTMLOpenPage -TitleText 'Tab Test' 
$rpt += Get-HTMLTabHeader -TabNames $tabarray 
foreach ($tab in $tabarray ){
	$rpt += get-htmltabcontentopen -TabName $tab -tabheading ($tab + ' this is your tab' )
		$rpt += Get-HTMLContentText -Heading "$tab" -Detail "$tab" 
	$rpt += get-htmltabcontentclose
}
$rpt += Get-HTMLClosePage
Save-HTMLReport -ReportContent $rpt -ShowReport
'@


$tabarray = @('Sample1','Sample2','Sample3','Sample4')
$TabExample = @()
$TabExample += Get-HTMLTabHeader -TabNames $tabarray 
foreach ($tab in $tabarray ){
       $TabExample += get-htmltabcontentopen -TabName $tab -tabheading ($tab + ' this is your tab' )
       $TabExample += Get-HTMLContentText -Heading "$tab" -Detail "$tab"
       $TabExample += get-htmltabcontentclose
}
      
      # 'Tabs'
      $Tab = 'Tabs'
      $rpt += get-htmltabcontentopen -TabName $Tab -tabheading ' '
            $rpt += Get-HTMLContentOpen -HeaderText "Using Tabs in your Reports" -BackgroundShade 2
                  $rpt += Get-HTMLContentOpen -HeaderText "Creating Tabs"
				  		$rpt += Get-HTMLContentText -Heading "Tabs" -Detail 'If you are here, you already know what tabs are.  Here is the code'
                        $rpt += Get-HTMLContentText -Heading "Code" -Detail (get-htmlcodeblock -style powershell -code $TabCode)
                  $rpt += Get-HTMLContentClose  
                  $rpt += Get-HTMLContentOpen -HeaderText "Output"
                        $rpt +=  $TabExample
                  $rpt += Get-HTMLContentClose
            $rpt += Get-HTMLContentClose
      $rpt += get-htmltabcontentclose
#endregion

#region Sections
      
$Content1Code = @'
$rpt += Get-HTMLContentOpen -HeaderText "Welcome to your content" 
	$rpt += Get-HTMLContentText -Heading "This is simple content open" -Detail "Every time you use get-htmlContentopen you need to use Get-HTMLContentClose " 
$rpt += Get-HTMLContentClose 
'@
      
$Content1Output = @()
$Content1Output += Get-HTMLContentOpen -HeaderText "Welcome to your content" 
$Content1Output += Get-HTMLContentText -Heading "This is simple content open" -Detail "Every time you use get-htmlContentopen you need to use Get-HTMLContentClose " 
$Content1Output += Get-HTMLContentClose
      
$Content2Code = @'
$process = Get-Process | select -First 10
$rpt += Get-HTMLContentOpen -HeaderText "Hiding content" -IsHidden 
	$rpt += Get-HTMLContentTable $process 
$rpt += Get-HTMLContentClose 
'@

$Content2Output = @()
$Content2Output += Get-HTMLContentOpen -HeaderText "Hiding content" -IsHidden 
$Content2Output += Get-HTMLContentTable ($process | Select -First 5)
$Content2Output += Get-HTMLContentClose

$Content3Code = @'
$process = Get-Process | select -First 10
$rpt= @()
$rpt+= Get-HTMLContentOpen -HeaderText "Background Shade level 5" -BackgroundShade 5
	$rpt+= Get-HTMLContentOpen -HeaderText "Background Shade level 4" -BackgroundShade 4
		$rpt+= Get-HTMLContentOpen -HeaderText "Background Shade level 3" -BackgroundShade 3
			$rpt+= Get-HTMLContentOpen -HeaderText "Background Shade level 2" -BackgroundShade 2
				$rpt+= Get-HTMLContentOpen -HeaderText "Background Shade level 1" -BackgroundShade 1
					$rpt+= Get-HTMLContentTable ($process | Select -First 5)
				$rpt+= Get-HTMLContentClose
			$rpt+= Get-HTMLContentClose
		$rpt+= Get-HTMLContentClose
	$rpt+= Get-HTMLContentClose
$rpt+= Get-HTMLContentClose
'@

$Content3Output = @()
$Content3Output += Get-HTMLContentOpen -HeaderText "Background Shade level 5" -BackgroundShade 5
	$Content3Output += Get-HTMLContentOpen -HeaderText "Background Shade level 4" -BackgroundShade 4
		$Content3Output += Get-HTMLContentOpen -HeaderText "Background Shade level 3" -BackgroundShade 3
			$Content3Output += Get-HTMLContentOpen -HeaderText "Background Shade level 2" -BackgroundShade 2
				$Content3Output += Get-HTMLContentOpen -HeaderText "Background Shade level 1" -BackgroundShade 1
					$Content3Output += Get-HTMLContentTable ($process | Select -First 5)
				$Content3Output += Get-HTMLContentClose
			$Content3Output += Get-HTMLContentClose
		$Content3Output += Get-HTMLContentClose
	$Content3Output += Get-HTMLContentClose
$Content3Output += Get-HTMLContentClose

      # 'Loading Sections'
      $Tab = 'Sections'
      $rpt += get-htmltabcontentopen -TabName $Tab -tabheading ' '
      
            $rpt += Get-HTMLContentOpen -HeaderText "Sections" -BackgroundShade 3
                $rpt += Get-HTMLContentOpen -HeaderText "Creating Sections" -BackgroundShade 2
                	$rpt += Get-HTMLContentOpen -HeaderText "Code" 
                    	    $rpt += Get-HTMLContentText -Heading "Example" -Detail (get-htmlcodeblock -style powershell -code $Content1Code)
                  	$rpt += Get-HTMLContentClose
                        $rpt += $Content1Output
                  	$rpt += Get-HTMLContentClose  
            		
					$rpt += Get-HTMLContentOpen -HeaderText "Hiding Sections" -BackgroundShade 2
                  		$rpt += Get-HTMLContentOpen -HeaderText "Code" 
                        	$rpt += Get-HTMLContentText -Heading "Example" -Detail (get-htmlcodeblock -style powershell -code $Content2Code)
                  		$rpt += Get-HTMLContentClose
                        	$rpt += $Content2Output
                  	$rpt += Get-HTMLContentClose  
	            
					$rpt += Get-HTMLContentOpen -HeaderText "Shading" -BackgroundShade 2
                  		$rpt += Get-HTMLContentOpen -HeaderText "Code" 
                        	$rpt += Get-HTMLContentText -Heading "Example" -Detail (get-htmlcodeblock -style powershell -code $Content3Code)
                  		$rpt += Get-HTMLContentClose
                        	$rpt += $Content3Output
                  	$rpt += Get-HTMLContentClose  
	            
					
				$rpt += Get-HTMLContentClose
			
			$rpt += Get-HTMLContentClose
			
      $rpt += get-htmltabcontentclose
#endregion

#region Columns

$ColumnCode = @'
$MyProcesses= get-process | select Name,Id,PriorityClass,PagedMemorySize
$rpt= @()
$rpt+= Get-HtmlContentOpen -BackgroundShade 3 -HeaderText "Top and Bottom 5 Process"
	$rpt+= get-HtmlColumn1of2
		$rpt+= Get-HtmlContentOpen -BackgroundShade 2 -HeaderText 'Bottom 5 Process by Paged Memory'
			$rpt+= Get-HtmlContentTable  ($MyProcesses  | sort PagedMemorySize | select -First 5) 
		$rpt+= Get-HtmlContentClose
	$rpt+= get-htmlColumnClose
	$rpt+= get-htmlColumn2of2
		$rpt+= Get-HtmlContentOpen -BackgroundShade 2 -HeaderText 'Top 5 Process by Paged Memory'
			$rpt+= Get-HtmlContentTable  ($MyProcesses | sort PagedMemorySize | select -last 5) 
		$rpt+= Get-HtmlContentClose
	$rpt+= get-htmlColumnClose
$rpt+= Get-HtmlContentClose
'@
$MyProcesses= $process | select Name,Id,PriorityClass,Handles,FileVersion
$ColumnExample = @()
$ColumnExample += Get-HtmlContentOpen -BackgroundShade 3 -HeaderText "Top and Bottom 5 Process"
$ColumnExample += get-HtmlColumn1of2
$ColumnExample += Get-HtmlContentOpen -BackgroundShade 2 -HeaderText 'Bottom 5 Process by Paged Memory'
$ColumnExample += Get-HtmlContentTable  ($MyProcesses  | sort PagedMemorySize | select -First 5) 
$ColumnExample += Get-HtmlContentClose
$ColumnExample += get-htmlColumnClose
$ColumnExample += get-htmlColumn2of2
$ColumnExample += Get-HtmlContentOpen -BackgroundShade 2 -HeaderText 'Top 5 Process by Paged Memory'
$ColumnExample += Get-HtmlContentTable  ($MyProcesses | sort PagedMemorySize | select -last 5) 
$ColumnExample += Get-HtmlContentClose
$ColumnExample += get-htmlColumnClose
$ColumnExample += Get-HtmlContentClose

# 'Tabs'
      $Tab = 'Columns'
      $rpt += get-htmltabcontentopen -TabName $Tab -tabheading ' '
            $rpt += Get-HTMLContentOpen -HeaderText "Creating Columns in your Reports" -BackgroundShade 2
                  $rpt += Get-HTMLContentOpen -HeaderText "Code"
                        $rpt += Get-HTMLContentText -Heading "Example" -Detail (get-htmlcodeblock -style powershell -code $ColumnCode)
                  $rpt += Get-HTMLContentClose  
                  $rpt += Get-HTMLContentOpen -HeaderText "Output" -BackgroundShade 4
                        $rpt +=  $ColumnExample
                  $rpt += Get-HTMLContentClose
            $rpt += Get-HTMLContentClose
      $rpt += get-htmltabcontentclose

#endregion

#region Tables 

$TableCode1 = @'
$SampleList = get-process | select Name,Id,PriorityClass,PagedMemorySize,PrivateMemorySize,VirtualMemorySize -First 10 
$rpt= @() 
$rpt+= Get-HtmlContentOpen -HeaderText "Processes"
	$rpt+= Get-HtmlContentTable $SampleList 
$rpt+= Get-HtmlContentClose 
'@

$SampleList1 = $process | select -First 10
$TableExample1 = @()
$TableExample1 += Get-HtmlContentOpen -HeaderText "Processes"
$TableExample1 += Get-HtmlContentTable -ArrayOfObjects $SampleList1
$TableExample1 += Get-HtmlContentClose


$TableCode2 = @'
$SampleList = get-process 
$rpt= @()
$rpt+= Get-HtmlContentOpen -HeaderText "Processes" 
	$rpt+= Get-HtmlContentTable $SampleList 
$rpt+= Get-HtmlContentClose
'@

$SampleList2 = $process | select -First 20
$TableExample2 = @()
$TableExample2 += Get-HtmlContentOpen -HeaderText "Processes"
$TableExample2 += Get-HtmlContentTable -ArrayOfObjects $SampleList2 -GroupBy PriorityClass
$TableExample2 += Get-HtmlContentClose

$TableCode3 = @'
$SampleList3 = get-process
$rpt = @()
$rpt += Get-HtmlContentOpen -HeaderText "Processes, 2 fixed table one not."
$rpt += Get-HtmlContentTable -ArrayOfObjects ($SampleList3 | select -first 4) -Fixed
$rpt += Get-HTMLContentText -Heading ' ' -Detail ' '
$rpt += Get-HtmlContentTable -ArrayOfObjects ($SampleList3 | select -last 4) -Fixed
$rpt += Get-HtmlContentClose
'@

$SampleList3 = $process
$TableExample3 = @()
$TableExample3 += Get-HtmlContentOpen -HeaderText "Processes, 2 fixed tables."
$TableExample3 += Get-HtmlContentTable -ArrayOfObjects ($SampleList3 | select -first 4)  -Fixed
$TableExample3 += Get-HTMLContentText -Heading ' ' -Detail ' ' 
$TableExample3 += Get-HtmlContentTable -ArrayOfObjects ($SampleList3 | select -last 8) -Fixed
$TableExample3 += Get-HtmlContentClose




# 'Tabs'
      $Tab = 'Tables'
      $rpt += get-htmltabcontentopen -TabName $Tab -tabheading ' '
            $rpt += Get-HTMLContentOpen -HeaderText "Display PowerShell arrays using tables" -BackgroundShade 3          
                  $rpt += Get-HTMLContentOpen -HeaderText "Simple Example" -BackgroundShade 2
                        $rpt += Get-HTMLContentOpen -HeaderText "Example"
                              $rpt += Get-HTMLContentText -Heading "Sortable Headers" -Detail 'Simple Tables are sortable click the header'
							  $rpt += Get-HTMLContentText -Heading "Code" -Detail (Get-HTMLcodeblock -style powershell -code $TableCode1)
                        $rpt += Get-HTMLContentClose  
                        $rpt +=  $TableExample1
                  $rpt += Get-HTMLContentClose
            
				#GROUPED      
                  $rpt += Get-HTMLContentOpen -HeaderText "Grouped Example" -BackgroundShade 2
                        $rpt += Get-HTMLContentOpen -HeaderText "Example"
                              $rpt += Get-HTMLContentText -Heading "Using Expressions" -Detail 'If you want to rename your column header or use calculated columns you can use expressions.  <br> @{Name="Virtual Memory Size";Expression={$_.VirtualMemorySize  / 1Kb }' 
                              $rpt += Get-HTMLContentText -Heading "Code" -Detail (Get-HTMLcodeblock -style powershell -code $TableCode2)
                        $rpt += Get-HTMLContentClose  
                        $rpt +=  $TableExample2
                  $rpt += Get-HTMLContentClose
				  
				  #fixed width
				   $rpt += Get-HTMLContentOpen -HeaderText "Fixed Width" -BackgroundShade 2
                        $rpt += Get-HTMLContentOpen -HeaderText "Example"
                              $rpt += Get-HTMLContentText -Heading "Column Width" -Detail 'Sometimes you may be display data and the column will dynamically shift.  You can use the -fixed switch' 
                              $rpt += Get-HTMLContentText -Heading "Code" -Detail (Get-HTMLcodeblock -style powershell -code $TableCode3)
                        $rpt += Get-HTMLContentClose  
                        $rpt +=  $TableExample3
                  $rpt += Get-HTMLContentClose
				  
            $rpt += Get-HTMLContentClose  
      $rpt += get-htmltabcontentclose

#endregion

#region Row Colour

$TableCode4 = @'
$SampleList = get-process | select -First 20
$rpt= @()
$rpt+= Get-HtmlContentOpen -HeaderText "Processes"
$SampleListColour = Set-TableRowColor $SampleList2 -Alternating
$rpt+= Get-HtmlContentTable -ArrayOfObjects $SampleListColour 
$rpt+= Get-HtmlContentClose
'@

$SampleList2 = $process | select -First 20
$TableExample4 = @()
$TableExample4 += Get-HtmlContentOpen -HeaderText "Processes"
$SampleListColour = Set-TableRowColor $SampleList2 -Alternating
$TableExample4 += Get-HtmlContentTable -ArrayOfObjects $SampleListColour 
$TableExample4 += Get-HtmlContentClose

$ColourRow = @'
# You must use single quotes here for the expression
$Red = '$this.Handles   -ge 800'
$Yellow = '$this.Handles   -gt 200 -or $this.Handles -lt 800'
$Green = '$this.Handles  -le 200'
 
# call the function and pass the array and color expressions
$ProcessColoured = Set-TableRowColor ($process | select -first 40) -Red $Red -Yellow $Yellow -Green $Green
 
# let's just see what the function did
$ProcessColoured | select name, Handles , RowColor 
 
$rpt = @()
$rpt += Get-HtmlContentOpen -HeaderText "Process with Row Colour Logic"
$rpt += Get-HtmlContentTable  ($ProcessColoured | Sort Handles) 
$rpt += Get-HtmlContentClose
'@

# You must use single quotes here for the expression and the work $this
$Red = '$this.Handles   -ge 400'
$Yellow = '$this.Handles   -gt 250 -or $this.Handles -lt 400'
$Green = '$this.Handles  -le 250'
 
# call the function and pass the array and color expressions
$ProcessColoured = Set-TableRowColor ($process | select -first 40) -Red $Red -Yellow $Yellow -Green $Green
 
$ProcessColouredrpt = @()
$ProcessColouredrpt += Get-HtmlContentOpen -HeaderText "Process with Row Colour Logic"
$ProcessColouredrpt += Get-HtmlContentTable ($ProcessColoured | Sort Handles)
$ProcessColouredrpt += Get-HtmlContentClose

      $Tab = 'Row Colour'
      $rpt += get-htmltabcontentopen -TabName $Tab -tabheading ' '
            $rpt += Get-HTMLContentOpen -HeaderText $Tab -BackgroundShade 2
			
				   $rpt += Get-HTMLContentOpen -HeaderText "Alternating" -BackgroundShade 2
                        $rpt += Get-HTMLContentOpen -HeaderText "Example"
                              $rpt += Get-HTMLContentText -Heading "Alternating Row Colour" -Detail 'How to set alternating row colour on an array' 
                              $rpt += Get-HTMLContentText -Heading "Code" -Detail (Get-HTMLcodeblock -style powershell -code $TableCode4)
                        $rpt += Get-HTMLContentClose  
                        $rpt +=  $TableExample4
                  $rpt += Get-HTMLContentClose
			
				$rpt += Get-HTMLContentOpen "Code"
                	  $rpt += Get-HTMLContentText -Heading "How to add colours to tables" -Detail "You can apply colours to a row using logic."
				  	$rpt += Get-HTMLContentText -Heading "Code" -Detail (get-htmlcodeblock -style PowerShell -code $ColourRow)
            	$rpt += Get-HTMLContentClose
					$rpt += $ProcessColouredrpt
			$rpt += Get-HTMLContentClose	
      $rpt += get-htmltabcontentclose
#endregion

#region HyperLinks

$HyperLinkCode1 = @'
#again this uses O but you should use 0
get-htmlcontenttext -heading "HyperLink" -Detail "URLO1https://www.azurefieldnotes.comURLO2Azure Field NotesURLO3"
'@

$HyperLinkExample1 = @()
$HyperLinkExample1 += "URL01https://www.azurefieldnotes.comURL02Azure Field NotesURL03"


$AnchorCode2 = @'
$rpt = @()
$Links = Get-HTMLContentText -Heading "Anchor Links" -Detail (( Get-HTMLAnchorLink -AnchorName "This" -AnchorText "This" ) + " | " + (Get-HTMLAnchorLink -AnchorName "Here" -AnchorText "Here"))
$rpt += $Links  
$rpt += Get-HTMLContentOpen -Anchor This
$rpt += Get-HTMLContentText -Heading "Anchor Example" -Detail "You can add anchors to HTMLContent open as well"
$rpt += Get-HTMLContentText -Heading "Anchors" -Detail "Used"
$rpt += Get-HTMLAnchor -AnchorName Here
$rpt += Get-HTMLContentClose
$rpt += $Links 
'@



$AnchorExample2 = @()
$Links = Get-HTMLContentText -Heading "Anchor Links" -Detail (( Get-HTMLAnchorLink -AnchorName "SampleTop" -AnchorText "SampleTop" ) + " | " + (Get-HTMLAnchorLink -AnchorName "SampleBottom" -AnchorText "SampleBottom"))
$AnchorExample2 += Get-HTMLContentOpen 
$AnchorExample2 += Get-HTMLContentText -Heading "Anchor Example" -Detail "You can add anchors to HTMLContent open as well"
$AnchorExample2 += Get-HTMLContentText -Heading "1 " -Detail " "
$AnchorExample2 += Get-HTMLContentText -Heading "2 " -Detail " "
$AnchorExample2 += Get-HTMLContentText -Heading "3 " -Detail " "
$AnchorExample2 += Get-HTMLContentText -Heading "4 " -Detail " "
$AnchorExample2 += Get-HTMLContentText -Heading "5 " -Detail " "
$AnchorExample2 += Get-HTMLContentText -Heading "6 " -Detail " "
$AnchorExample2 += Get-HTMLContentText -Heading "7 " -Detail " "
$AnchorExample2 += Get-HTMLContentText -Heading "8 " -Detail " "
$AnchorExample2 += Get-HTMLContentText -Heading "9 " -Detail " "
$AnchorExample2 += Get-HTMLContentText -Heading "10 " -Detail " "
$AnchorExample2 += Get-HTMLContentText -Heading "11 " -Detail " "
$AnchorExample2 += Get-HTMLContentText -Heading "12 " -Detail " "
$AnchorExample2 += Get-HTMLContentText -Heading "13 " -Detail " "
$AnchorExample2 += Get-HTMLContentText -Heading "14 " -Detail " "
$AnchorExample2 += Get-HTMLContentText -Heading "15 " -Detail " "
$AnchorExample2 += Get-HTMLContentText -Heading "16 " -Detail " "
$AnchorExample2 += Get-HTMLContentText -Heading "17 " -Detail " "
$AnchorExample2 += Get-HTMLContentText -Heading "18 " -Detail " "
$AnchorExample2 += Get-HTMLContentText -Heading "19 " -Detail " "
$AnchorExample2 += Get-HTMLContentText -Heading "20 " -Detail " "
$AnchorExample2 += Get-HTMLContentText -Heading "21 " -Detail " "
$AnchorExample2 += Get-HTMLContentText -Heading "22 " -Detail " "
$AnchorExample2 += Get-HTMLContentText -Heading "23 " -Detail " "
$AnchorExample2 += Get-HTMLContentText -Heading "24 " -Detail " "
$AnchorExample2 += Get-HTMLContentText -Heading "25 " -Detail " "
$AnchorExample2 += Get-HTMLContentText -Heading "26 " -Detail " "
$AnchorExample2 += Get-HTMLContentText -Heading "26.5 " -Detail " "
$AnchorExample2 += Get-HTMLContentText -Heading "26.7 " -Detail " "
$AnchorExample2 += Get-HTMLContentText -Heading ".... " -Detail " "
$AnchorExample2 += Get-HTMLContentText -Heading "30 " -Detail " "
$AnchorExample2 += Get-HTMLContentClose



# 'Tabs'
      $Tab = 'HyperLinks'
	  $rpt +=  Get-HTMLAnchor -AnchorName "SampleTop"
      $rpt += get-htmltabcontentopen -TabName $Tab -tabheading ' '
            #HyperLinks
            $rpt += Get-HTMLContentOpen -HeaderText "Adding Hyperlinks" -BackgroundShade 2
                  $rpt += Get-HTMLContentOpen -HeaderText "Code"
                        $rpt += Get-HTMLContentText -Heading "How it works" -Detail "A hyper link is uses A tags and a link with a hyperlink behind it.  <BR>  To build a hyper link we use a find and replace style.  This allows you to create a hyperlink in any data set.  <BR> To create a hyper link you need to use U R L 0 1, U R L 0 2 and U R L 0 3 as text (with no spaces).  <BR>or written with O's not 0's The format you need to follows is URLO1 HyperLink URLO2 LinkText URLO3"
                        $rpt += Get-HTMLContentText -Heading "Example" -Detail (get-htmlcodeblock -style powershell -code $HyperLinkCode1)
                  $rpt += Get-HTMLContentClose  
                  $rpt += Get-HTMLContentOpen -HeaderText "Output" -BackgroundShade 3
                        $rpt +=  get-htmlcontenttext -heading "HyperLink" -Detail "URL01https://www.azurefieldnotes.comURL02Azure Field NotesURL03"
                  $rpt += Get-HTMLContentClose
				   $rpt += Get-HTMLContentOpen -HeaderText "Code"
                        $rpt += Get-HTMLContentText -Heading "New Tab" -Detail "To build a hyper link that will open in a new tab use NEW at the end of the first reference word <BR> U R L 0 1 N E W, U R L 0 2 and U R L 0 3 as text (with no spaces).  <BR>or written with O's not 0's The format you need to follows is URLO1NEW HyperLink URLO2 LinkText URLO3"
                        $rpt += Get-HTMLContentText -Heading "Example" -Detail (get-htmlcodeblock -style powershell -code $HyperLinkCode1)
                  $rpt += Get-HTMLContentClose  
                  $rpt += Get-HTMLContentOpen -HeaderText "Output" -BackgroundShade 3
                        $rpt +=  get-htmlcontenttext -heading "HyperLink" -Detail "URL01NEWhttps://www.azurefieldnotes.comURL02Azure Field Notes opening in a new tabURL03"
                  $rpt += Get-HTMLContentClose
            $rpt += Get-HTMLContentClose
            
            #Anchors
            $rpt += Get-HTMLContentOpen -HeaderText "Adding Anchors and Links" -BackgroundShade 2
                  $rpt += Get-HTMLContentOpen -HeaderText "Code"
                        $rpt += Get-HTMLContentText -Heading "Example" -Detail  (get-htmlcodeblock -style powershell -code $AnchorCode2)
                  $rpt += Get-HTMLContentClose  
                  $rpt += Get-HTMLContentOpen -HeaderText "Output" -BackgroundShade 3 -Anchor "SampleTop"
                        $rpt +=  $links
						$rpt +=  $AnchorExample2
						$rpt +=  $links
                  $rpt += Get-HTMLContentClose
            $rpt += Get-HTMLContentClose
			$rpt +=  Get-HTMLAnchor -AnchorName "SampleBottom"
      $rpt += get-htmltabcontentclose

#endregion

#region Charts

$ChartCode1 =@'
$Process = Get-Process
$PieProcess = $process | group ProcessName | sort count -Descending |select -First 5

$PieObject = Get-HTMLPieChartObject

$rpt = @()
$rpt += Get-HTMLOpenpage
	$rpt += Get-HTMLContentOpen	 -HeaderText "Simple Example"
		$rpt += Get-HTMLPieChart -ChartObject $PieObject -DataSet $PieProcess 
	$rpt += Get-HTMLContentClose
$rpt += Get-HTMLClosePage

save-htmlreport -reportcontent $rpt -showreport 
'@
$PieProcess = $process | group Name | sort count -Descending |select -First 5
$ChartExample1 = @()
$ChartExample1 += Get-HTMLContentOpen -HeaderText "Simple Example"
$PieObject = Get-HTMLPieChartObject
$ChartExample1 += Get-HTMLPieChart -ChartObject $PieObject -DataSet $PieProcess 
$ChartExample1 += Get-HTMLContentClose

$ChartCode2 =@'
$Process = Get-Process
$PieProcess2 = $process | group ProcessName | sort count -Descending |select -First 5

#basic Properties 
$PieObject2 = Get-HTMLPieChartObject
$PieObject2.Title = "Top Processes"
$PieObject2.Size.Height =250
$PieObject2.Size.width =250
$PieObject2.ChartStyle.ChartType = 'doughnut'

#These file exist in the module directoy, There are 4 schemes by default
$PieObject2.ChartStyle.ColorSchemeName = "ColorScheme4"
#There are 8 generated schemes, randomly generated at runtime 
$PieObject2.ChartStyle.ColorSchemeName = "Generated8"
#you can also ask for a random scheme.  Which also happens if you have too many records for the scheme
$PieObject2.ChartStyle.ColorSchemeName = 'Random'

#Data defintion you can reference any column from name and value from the  dataset.  
#Name and Count are the default to work with the Group function.
$PieObject2.DataDefinition.DataNameColumnName ='Name'
$PieObject2.DataDefinition.DataValueColumnName = 'Count'

$rpt = @()
$rpt += Get-HTMLopenpage -TitleText Title
	$rpt += Get-HTMLContentOpen -HeaderText "Advanced Example"
		$rpt += Get-HTMLPieChart -ChartObject $PieObject2 -DataSet $PieProcess 
	$rpt += Get-HTMLContentClose
$rpt += Get-HTMLclosepage

save-htmlreport -reportcontent $rpt -showreport 
'@
$ColorSchemes = Get-HTMLColorSchemes
$PieProcess = $process | group Name | sort count -Descending |select -First 5

#basic Properties 
$PieObject2 = Get-HTMLPieChartObject
$PieObject2.Title = "Top Processes"
$PieObject2.Size.Height =250
$PieObject2.Size.width =250
$PieObject2.ChartStyle.ChartType = 'doughnut'

#These file exist in the module directoy, There are 4 schemes by default
$PieObject2.ChartStyle.ColorSchemeName = "ColorScheme4"
#There are 8 generated schemes, randomly generated at runtime 
$PieObject2.ChartStyle.ColorSchemeName = "Generated8"
#you can also ask for a random scheme.  Which also happens if you have too many records for the scheme
$PieObject2.ChartStyle.ColorSchemeName = 'Random'

#Data defintion you can reference any column from name and value from the  dataset.  
#Name and Count are the default to work with the Group function.
$PieObject2.DataDefinition.DataNameColumnName ='Name'
$PieObject2.DataDefinition.DataValueColumnName = 'Count'
$ChartExample2 = @()
#$ChartExample2 += Get-HTMLopenpage -TitleText t
$ChartExample2 += Get-HTMLContentOpen -HeaderText "Advanced Example"
$ChartExample2 += Get-HTMLPieChart -ChartObject $PieObject2 -DataSet $PieProcess 
$ChartExample2 += Get-HTMLContentClose
#$ChartExample2 += Get-HTMLclosepage
#save-htmlreport -reportcontent $ChartExample2 -showreport 

$ChartCode3 =@'
$Process = Get-Process
$BarProcess = $process | group Name | sort count -Descending |select -First 10

$ChartExample3 = @()
$ChartExample3 += Get-HTMLContentOpen -HeaderText "Simple Bar Example"
$BarObject = Get-HTMLBarChartObject
$ChartExample3 += Get-HTMLBarChart -ChartObject $BarObject -DataSet $BarProcess 
$ChartExample3 += Get-HTMLContentClose

save-htmlreport -reportcontent $rpt -showreport 
'@
$BarProcess = $process | group Name | sort count -Descending |select -First 8
$ChartExample3 = @()
$ChartExample3 += Get-HTMLContentOpen -HeaderText "Simple Bar Example"
$BarObject = Get-HTMLBarChartObject
$BarObject.ChartStyle.legendPosition = 'none'
$ChartExample3 += Get-HTMLBarChart -ChartObject $BarObject -DataSet $BarProcess 
$ChartExample3 += Get-HTMLContentClose


      $Tab = 'Charts'
      $rpt += get-htmltabcontentopen -TabName $Tab -tabheading ' '
            $rpt += Get-HTMLContentOpen -HeaderText $Tab 
                $rpt += Get-HTMLContentText -Heading "Chart JS" -detail "Rather than reinvent charting and because we wanted to be able to generate charts in Azure Automation I used Chart JS"
				$rpt += Get-HTMLContentText -Heading "Chart JS Project" -detail "URL01http://www.chartjs.org/URL02Chart JS SiteURL03 Simple HTML5 charts using the canvas element."
				$rpt += Get-HTMLContentText -Heading "Possiblities" -detail "I will explain a few example and how the chart bject works for rapid creation however you can always create your own chart code and add it"
			$rpt += Get-HTMLContentClose
			$rpt += Get-HTMLContentOpen -HeaderText 'Charts' -BackgroundShade 3
				$rpt += Get-HTMLContentOpen -HeaderText "Code"
					$rpt += Get-HTMLContentText -Heading "Simple Example" -Detail (get-htmlcodeblock -style powershell -code $ChartCode1)
				$rpt += Get-HTMLContentClose  
                $rpt += Get-HTMLContentOpen -HeaderText "Output" -BackgroundShade 2
					$rpt +=  $ChartExample1
                $rpt += Get-HTMLContentClose
			
				$rpt += Get-HTMLContentOpen -HeaderText "Code"
					$rpt += Get-HTMLContentText -Heading "Advanced Example" -Detail (get-htmlcodeblock -style powershell -code $ChartCode2)
				$rpt += Get-HTMLContentClose  
                $rpt += Get-HTMLContentOpen -HeaderText "Output" -BackgroundShade 2
                    $rpt +=  $ChartExample2
                $rpt += Get-HTMLContentClose
			
				$rpt += Get-HTMLContentOpen -HeaderText "Code"
					$rpt += Get-HTMLContentText -Heading "Bar Chart Example" -Detail (get-htmlcodeblock -style powershell -code $ChartCode3)
				$rpt += Get-HTMLContentClose  
                $rpt += Get-HTMLContentOpen -HeaderText "Output" -BackgroundShade 2
                    $rpt +=  $ChartExample3
                $rpt += Get-HTMLContentClose
			
			$rpt += Get-HTMLContentClose
			
      $rpt += get-htmltabcontentclose
#endregion

#region Javascript
      $Tab = 'JavaScript'
      $rpt += get-htmltabcontentopen -TabName $Tab -tabheading ' '
            $rpt += Get-HTMLContentOpen -HeaderText 'The Basics' 
                  $rpt += Get-HTMLContentText -Heading "Scripts" -detail "There are a couple of scripts that are located in the module directory.<BR>These scripts are loaded when you run Get-HTMLopenpage. <BR>you can use Get-HTMLJavaScripts to retrieve them . What this means though<BR>is that you can simply drop your own javascripts into the directory, <BR>or use the function to point at another directory and load custom code."
            $rpt += Get-HTMLContentClose
      $rpt += get-htmltabcontentclose
#endregion

#region HTML


$SampleCode=@'
$Tab = 'JavaScript'
  $rpt += get-htmltabcontentopen -TabName $Tab -tabheading ' '
        $rpt += Get-HTMLContentOpen -HeaderText 'The Basics' 
              $rpt += Get-HTMLContentText -Heading "Scripts" -detail "There are a couple of scripts that are located in the module directory"
        $rpt += Get-HTMLContentClose
  $rpt += get-htmltabcontentclose
'@


$CodeBlock =@'

    $SampleCode=@'
    $Tab = 'JavaScript'
      $rpt += get-htmltabcontentopen -TabName $Tab -tabheading ' '
            $rpt += Get-HTMLContentOpen -HeaderText 'The Basics' 
                  $rpt += Get-HTMLContentText -Heading "Scripts" -detail "There are a couple of scripts that are located in the module directory"
            $rpt += Get-HTMLContentClose
      $rpt += get-htmltabcontentclose
    '@

    $rpt += Get-HTMLContentText -Heading "PowerShell Function" -detail (get-htmlcodeblock -style powershell -code $SampleCode)


'@
$FunctionBlock=@'
Function Get-HTMLCodeBlock
{
	[CmdletBinding()]
	Param 
	(
		[Parameter(Mandatory=$true)]
        [String]
        $Code,
		[Parameter(Mandatory=$false)]
        [String]
        $Style = 'PowerShell'
	)
	$CodeBlock = @()
	switch ($Style) {
		'PowerShell'
		{
			$CodeBlock += '<pre class="PowerShell">'
		}
		'othercodestyleneedsACSSStyle'
		{
			$CodeBlock += '<pre class="PowerShell">'
		}
		default 
		{
			$CodeBlock += '<pre>'
		}
	}
	
	$CodeBlock  += $Code
	$CodeBlock  += '</pre>'
	[string]$CodeBlock = $CodeBlock
	Write-Output $CodeBlock
}
'@




      $Tab = 'HTML'
      $rpt += get-htmltabcontentopen -TabName $Tab -tabheading ' '
            $rpt += Get-HTMLContentOpen -HeaderText 'Custom HTML' 
                  $rpt += Get-HTMLContentText -Heading "HTML" -detail "You can use any html tags and code and add it directy to the Report array"
				  $rpt += Get-HTMLContentText -Heading "Tags in text" -detail "you can use things like < B R ><br> for example in a string for a break"
            $rpt += Get-HTMLContentClose
			$rpt += Get-HTMLContentOpen -HeaderText 'Consume other HTML Fucntions' 
                  $rpt += Get-HTMLContentText -Heading "Convertto-advhtml" -detail " you can trying using this cmdlet URL01https://thesurlyadmin.com/2014/02/27/convertto-advhtml-new-advanced-function-for-html-reporting/URL02ConvertTo-AdvHTML'"
				  $rpt += Get-HTMLContentText -Heading "Adding it to the array" -detail 'just keep adding it to $rpt += $newcode'
            $rpt += Get-HTMLContentClose
			$rpt += Get-HTMLContentOpen -HeaderText 'Creating Custom functions' 
                  $rpt += Get-HTMLContentText -Heading "Get-HTMLCodeBlock" -detail "To create this help file I just created get-htmlcodeblock so I could use the < PRE > HTML tag.  <BR>I decided that I would pass the code block into the function and choose a style and wrap the code in the tags<BR>I had to add a CSS style to the CSS file to support this function"
				  $rpt += Get-HTMLContentText -Heading "PowerShell Function" -detail (get-htmlcodeblock -style powershell -code $FunctionBlock)
				  $rpt += Get-HTMLContentText -Heading "PowerShell Code" -detail (get-htmlcodeblock -style powershell -code $CodeBlock)
				  $rpt += Get-HTMLContentText -Heading "Output" -Detail (get-htmlcodeblock -style powershell -code $SampleCode)
				  
            $rpt += Get-HTMLContentClose
      $rpt += get-htmltabcontentclose
#endregion

#region Functions
      $FunctionList = @()
      $FunctionList  += Get-Functions -path $ModulePath

      $Tab = 'Functions'
      $rpt += get-htmltabcontentopen -TabName $Tab -tabheading ' '
      $rpt += Get-HTMLAnchor -AnchorName "Top"
            $rpt += Get-HtmlContentOpen -HeaderText "Available Functions "  
                  $rpt += ($FunctionList | % { (Get-HTMLAnchorLink -AnchorName $_.FunctionName -AnchorText $_.FunctionName ) + '<BR>'} )
            $rpt += Get-HtmlContentclose
                  $rpt += Get-HtmlContentOpen -HeaderText "Functions with Parameters" -BackgroundShade 2
                  foreach ($function in ( $FunctionList | sort FunctionName)){
                        $rpt += Get-HTMLAnchorlink -AnchorName Top -AnchorText 'Back To Function List'
                        $Params = @(Get-Parameters -Cmdlet $function.FunctionName)
                        $rpt += get-HTMLAnchor -Anchor $function.FunctionName
                        if ($Params.count -gt 0) {
                              $rpt += Get-HtmlContentOpen  -HeaderText ($function.FunctionName)
                              $FunctionHelp = Get-Help $function.FunctionName
                              $rpt += Get-HTMLContentText -Heading "Name" -Detail ($FunctionHelp.Name)
                              $rpt += Get-HTMLContentText -Heading "Synopsis" -Detail ($FunctionHelp.synopsis)
                              $rpt += Get-HTMLContentText -Heading "Remarks" -Detail ($FunctionHelp.Remarks)
                              $rpt += Get-HTMLContentText -Heading "Examples" -Detail ($FunctionHelp.Examples)
                                    $rpt += Get-HtmlContentOpen -HeaderText 'Functions Parameters'
                                          $rpt += Get-HtmlContentTable (Set-TableRowColor ($Params | select ParameterSet, Name ,Type ,IsMandatory  ,Pipeline ) -Alternating ) -GroupBy ParameterSet -Fixed 
                                    $rpt += Get-HtmlContentclose
                              $rpt += Get-HtmlContentclose
                        }
                  }
                $rpt += Get-Htmlcontentclose
            $rpt += get-htmltabcontentclose
      $rpt += get-htmltabcontentclose

#Endregion
   
#Region End Report function

      $Helpfile = Save-HTMLReport -ReportContent $rpt -ReportPath $ModulePath -ReportName Help-ReportHTML
      Write-Output $Helpfile 
}
else
{
	$Helpfile = Join-Path $ModulePath Help-ReportHTML.html
	Invoke-Item $Helpfile
}
}

#endregion

