#!/bin/sh

echo "Content-type: text/html; charset=utf-8"
echo

if [ "$REQUEST_METHOD" = POST ]; then
     
    read boundary
    read disposition
    read ctype
    read junk
       
    a=${#boundary}
    b=${#disposition}
    c=${#ctype}
    a=$((a*2+b+c+d+10))

    len=$((CONTENT_LENGTH-a))
    
    dir=/tmp
    file=$(echo "$disposition" | egrep -o '"[^"]*"' | tail -n1 | egrep -o '[^"]*')
    
    # Проверяем свободное место.
    
    dd ibs=1 obs=512 count=$len of=$dir/$file
    
    fsize=$(wc -c $dir/$file | cut -f 1 -d ' ')
    
    if [[ $fsize -eq $len ]] ; then
    
        sysupgrade $dir/$file &
        
        echo "Файл загружен: $dir/$file ($fsize байт)."
        
    else
        
        echo "Размер загруженно файла отличается: $dir/$file ($fsize)."
    fi
    
else

    exit 0
fi

