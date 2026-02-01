$DataRoot = "D:\SynologyDrive\04. Data\04. Laser test"
$H5WhaleBaseUrl = "http://localhost:8080"  # <-- change if your h5web port is different
$OutFile = "D:\h5whale\file_index\index.html"

function RelUrlPath([string]$fullPath) {
  $rel = $fullPath.Substring($DataRoot.Length).TrimStart('\')
  $segments = $rel -split '\\'
  $encoded = $segments | ForEach-Object { [System.Uri]::EscapeDataString($_) }
  return ($encoded -join '/')
}

$files = Get-ChildItem -Path $DataRoot -Recurse -File |
  Where-Object { $_.Extension -in ".h5", ".hdf5", ".nx" } |
  Sort-Object FullName

$html = @()
$html += "<!doctype html><html><head><meta charset='utf-8'><title>h5whale files</title>"
$html += "<style>body{font-family:system-ui,Segoe UI,Arial,sans-serif;margin:20px} input{width:100%;padding:8px;margin:10px 0} li{margin:4px 0}</style>"
$html += "</head><body>"   
$html += "<h2>Available files</h2>"
$html += "<p>Click a file to open it in h5whale.</p>"
$html += "<input id='q' placeholder='Filter…' oninput='filter()'/>"
$html += "<ul id='list'>"

foreach ($f in $files) {
  $rel = $f.FullName.Substring($DataRoot.Length).TrimStart('\')
  $urlPath = RelUrlPath $f.FullName
  $href = "$H5WhaleBaseUrl/?file=$urlPath"
  $safeLabel = [System.Security.SecurityElement]::Escape($rel)
  $html += "<li><a href='$href' target='_blank'>$safeLabel</a></li>"
}

$html += "</ul>"
$html += "<script>
function filter(){
  const q=document.getElementById('q').value.toLowerCase();
  for (const li of document.querySelectorAll('#list li')){
    li.style.display = li.textContent.toLowerCase().includes(q) ? '' : 'none';
  }
}
</script>"
$html += "</body></html>"

New-Item -ItemType Directory -Force -Path (Split-Path $OutFile) | Out-Null
Set-Content -Path $OutFile -Value ($html -join "`n") -Encoding UTF8
Write-Host "Wrote $OutFile with $($files.Count) links."
