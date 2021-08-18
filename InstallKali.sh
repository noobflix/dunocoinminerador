#! / data / data / com.termux / files / usr / bin / bash

eco
echo -e "\ e [93mEste script instalará o Kali Linux no Termux."
eco
echo -e "\ e [32m [*] \ e [34mChecendo RootFS ..."
pasta = "kali-fs"
if [-d $ pasta]; então
	pular = 1
	echo -e "\ e [32m [*] \ e [34mRootFS já foi baixado, pulando o download ..."
fi
tarball = "kali-rootfs.tar.xz"
if ["$ skip"! = 1]; então
	E se [ ! -f $ tarball]; então
		echo -e "\ e [32m [*] \ e [34mDetectando arquitetura de CPU ..."
		case $ (dpkg --print-architecture) em
		aarch64)
			archurl = "arm64" ;;
		braço)
			archurl = "armhf" ;;
		amd64)
			archurl = "amd64" ;;
		x86_64)
			archurl = "amd64" ;;	
		i * 86)
			archurl = "i386" ;;
		x86)
			archurl = "i386" ;;
		*)
			eco; echo -e "\ e [91mDetectou arquitetura de CPU não suportada!"; eco; saída 1 ;;
		esac
		echo -e "\ e [32m [*] \ e [34m Baixando RootFS (~ 70Mb) para $ {archurl} ..."
		wget "https://raw.githubusercontent.com/EXALAB/AnLinux-Resources/master/Rootfs/Kali/${archurl}/kali-rootfs-${archurl}.tar.xz" -O $ tarball -q
	fi
	cur = $ (pwd)
	mkdir -p "$ pasta"
	cd "$ pasta"
	echo -e "\ e [32m [*] \ e [34mDecompressing RootFS ..."
	proot --link2symlink tar -xf $ {cur} / $ {tarball} || (echo -e "\ e [91mFailed to decompress RootFS!"; echo; exit 1)
	cd "$ cur"
fi
mkdir -p kali-binds
bin = "start-kali.sh"
echo -e "\ e [32m [*] \ e [34mCriando script de inicialização ..."
cat> $ bin << - EOM
#! / data / data / com.termux / files / usr / bin / bash

cd \ $ (dirname \ $ 0)
## não definir LD_PRELOAD no caso do termux-exec estar instalado
cancelar LD_PRELOAD
comando = "proot"
comando + = "--link2symlink"
comando + = "-0"
comando + = "-r $ pasta"
if [-n "\ $ (ls -A kali-binds)"]; então
    para f em kali-binds / *; faça
      . \ $ f
    feito
fi
comando + = "-b / dev"
comando + = "-b / proc"
comando + = "-b kali-fs / tmp: / dev / shm"
## descomente a seguinte linha para ter acesso ao diretório home do termux
# command + = "-b /data/data/com.termux/files/home:/root"
## descomente a seguinte linha para montar / sdcard diretamente em / 
comando + = "-b / sdcard"
comando + = "-w / root"
comando + = "/ usr / bin / env -i"
comando + = "HOME = / root"
comando + = "PATH = / usr / local / sbin: / usr / local / bin: / bin: / usr / bin: / sbin: / usr / sbin: / usr / games: / usr / local / games"
comando + = "TERM = \ $ TERM"
comando + = "LANG = C.UTF-8"
comando + = "/ bin / bash --login"
com = "\ $ @"
if [-z "\ $ 1"]; então
    exec \ $ command
outro
    \ $ command -c "\ $ com"
fi
EOM
echo -e "\ e [32m [*] \ e [34m Configurando Shebang ..."
termux-fix-shebang $ bin
echo -e "\ e [32m [*] \ e [34m Definindo permissões de execução ..."
chmod + x $ bin
echo -e "\ e [32m [*] \ e [34mRemoving RootFS image ..."
rm -rf $ tarball
eco
echo -e "\ e [32mKali Linux foi instalado com sucesso! \ e [39m"
echo -e "\ e [32m Agora você pode iniciá-lo executando o comando ./${bin}. \ e [39m"
