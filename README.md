# crack-pdf
Automated PDF password recovery tool (Linux)

# To use it
This program is only usable under a Linux environment.

1. Clone the repository
```
git clone https://github.com/antonblaise/crack-pdf.git
```
2. Method 1: Put your target PDF(s) into the same directory/folder as _crack-pdf.sh_</br>
Method 2: Copy _crack\_pdf.sh_ and _requirements.sh_ into the directory/folder as your target PDF(s)

3. Run _crack\_pdf.sh_
```
  bash crack-pdf.sh
```
or
```
  chmod +x crack-pdf.sh
  ./crack-pdf.sh
```

# About this tool
This tool uses [Hashcat](https://hashcat.net/hashcat/) and [John The Ripper](https://github.com/openwall/john) to crack an encrypted PDF as the user specifies the password character types and length. Its performance solely depends on your hardware.
- Numbers only
- Alphanumeric (lowercase only)
- Alphanumeric (uppercase only)
- Alphanumeric (lower+upper cases)
- All alphanumeric + Symbols (May take forever)

