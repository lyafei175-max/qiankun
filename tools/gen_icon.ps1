$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing

$outPath = Join-Path $PSScriptRoot "..\RemoteWatch\Assets.xcassets\AppIcon.appiconset\AppIcon1024.png"
$outDir = Split-Path $outPath
if (-not (Test-Path $outDir)) { New-Item -ItemType Directory -Force -Path $outDir | Out-Null }

$w = 1024
$bmp = New-Object System.Drawing.Bitmap($w, $w)
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias

# background gradient blue-500 -> blue-800
$rect = New-Object System.Drawing.Rectangle(0, 0, $w, $w)
$c1 = [System.Drawing.Color]::FromArgb(59, 130, 246)
$c2 = [System.Drawing.Color]::FromArgb(30, 64, 175)
$brush = New-Object System.Drawing.Drawing2D.LinearGradientBrush($rect, $c1, $c2, [System.Drawing.Drawing2D.LinearGradientMode]::Vertical)
$g.FillRectangle($brush, $rect)

# white location pin
$white = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
$g.FillEllipse($white, 232, 120, 560, 560)
$pts = @(
    (New-Object System.Drawing.PointF(332, 614)),
    (New-Object System.Drawing.PointF(692, 614)),
    (New-Object System.Drawing.PointF(512, 880))
)
$g.FillPolygon($white, $pts)

# pin inner hole (dark blue)
$inner = New-Object System.Drawing.SolidBrush($c2)
$g.FillEllipse($inner, 382, 270, 260, 260)

$g.Dispose()
$bmp.Save($outPath, [System.Drawing.Imaging.ImageFormat]::Png)
$bmp.Dispose()
Write-Host "Icon saved: $outPath"
