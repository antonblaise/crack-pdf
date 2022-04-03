

if [[ -z $(command -v hashcat) ]]
then
  sudo apt install hashcat -y
fi

if [[ -z $(command -v mlocate) ]]
then
  sudo apt install mlocate -y
fi

sudo updatedb

if [[ -z $(locate pdf2john) ]]
then
  echo "Cloning JohnTheRipper into '${HOME}'."
  tmp=$PWD
  cd ~
  git clone https://github.com/openwall/john.git
  cd $tmp
fi

# final check
if [[ ! -z $(command -v hashcat) ]] && [[ ! -z $(command -v mlocate) ]] && [[ ! -z $(locate pdf2john) ]]
then
  printf """
  \033[1;32mAll required dependencies are present!\033[0m

"""
fi
