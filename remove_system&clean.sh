#!/bin/bash

# تأكيد قبل المتابعة
read -p "هاذ السكربت غادي يحذف جميع الحزم، واش متأكد؟ (yes/no): " confirm
if [[ "$confirm" != "yes" ]]; then
    echo "العملية توقفت."
    exit 1
fi

# تحديث النظام
sudo apt update

# الحصول على جميع الحزم المثبتة
packages=$(dpkg --get-selections | grep -v deinstall | awk '{print $1}')

# استثناء الحزم الأساسية اللي ضرورية للنظام
essential_packages=("bash" "coreutils" "dpkg" "apt" "gnupg" "systemd" "grub-pc" "login" "util-linux")

# حذف الحزم غير الأساسية
for pkg in $packages; do
    if [[ ! " ${essential_packages[@]} " =~ " ${pkg} " ]]; then
        echo "جاري حذف: $pkg"
        sudo apt remove --purge -y $pkg
    else
        echo "تخطي الحزمة الأساسية: $pkg"
    fi
done

# تنظيف الحزم غير الضرورية
sudo apt autoremove -y
sudo apt clean

echo "تم حذف جميع الحزم غير الأساسية بنجاح!"