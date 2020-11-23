#
# Copyright (C) 2010-2015 OpenWrt.org
#

. /lib/imx6.sh

RAMFS_COPY_BIN='blkid'

enable_image_metadata_check() {
	case "$(board_name)" in
		apalis*)
			REQUIRE_IMAGE_METADATA=1
			;;
		lumi*)
			REQUIRE_IMAGE_METADATA=0
			;;
	esac
}
enable_image_metadata_check

apalis_copy_config() {
	apalis_mount_boot
	cp -af "$UPGRADE_BACKUP" "/boot/$BACKUP_FILE"
	sync
	umount /boot
}

apalis_do_upgrade() {
	local board_name=$(board_name)
	board_name=${board_name/,/_}

	apalis_mount_boot
	get_image "$1" | tar Oxf - sysupgrade-${board_name}/kernel > /boot/uImage
	get_image "$1" | tar Oxf - sysupgrade-${board_name}/root > $(rootpart_from_uuid)
	sync
	umount /boot
}
lumi_do_upgrade() {
	local file_type=$(identify $1)
	echo $file_type

	if type 'platform_nand_pre_upgrade' >/dev/null 2>/dev/null; then
		platform_nand_pre_upgrade "$1"
	fi

	[ ! "$(find_mtd_index "$CI_UBIPART")" ] && CI_UBIPART="rootfs"

	case "$file_type" in
		"ubi")		lumi_upgrade_ubinized $1;;
		"ubifs")	lumi_upgrade_ubifs $1;;
		*)		lumi_upgrade_tar $1;;
	esac
}
lumi_upgrade_tar() {
	local tar_file="$1"
	local kernel_mtd="$(find_mtd_index $CI_KERNPART)"

	local board_dir=$(tar tf $tar_file | grep -m 1 '^sysupgrade-.*/$')
	board_dir=${board_dir%/}

	local kernel_length=`(tar xf $tar_file ${board_dir}/kernel -O | wc -c) 2> /dev/null`
	local rootfs_length=`(tar xf $tar_file ${board_dir}/root -O | wc -c) 2> /dev/null`

	local rootfs_type="$(identify_tar "$tar_file" ${board_dir}/root)"

	local has_kernel=1
	local has_env=0


	[ "$kernel_length" != 0 -a -n "$kernel_mtd" ] && {
		tar xf $tar_file ${board_dir}/kernel -O | mtd write - $CI_KERNPART
		echo "kernel -> mtd$kernel_mtd"
	}

	echo "root($rootfs_type) -> /dev/ubi0_0"
	tar xf $tar_file ${board_dir}/root -O | \
		ubiupdatevol /dev/ubi0_0 -s $rootfs_length -

	sync
	echo "sysupgrade successful"
	umount -a
	reboot -f

}

platform_check_image() {
	local board=$(board_name)

	case "$board" in
	apalis*)
		return 0
		;;
	*gw5*)
		nand_do_platform_check $board $1
		return $?;
		;;
	lumi*)
		nand_do_platform_check $board $1
		return $?;
		;;
	esac

	echo "Sysupgrade is not yet supported on $board."
	return 1
}

platform_do_upgrade() {
	local board=$(board_name)

	case "$board" in
	apalis*)
		apalis_do_upgrade "$1"
		;;
	*gw5*)
		nand_do_upgrade "$1"
		;;
	lumi*)
		lumi_do_upgrade "$1"
		;;
	esac
}

platform_copy_config() {
	local board=$(board_name)

	case "$board" in
	apalis*)
		apalis_copy_config
		;;
	esac
}

platform_pre_upgrade() {
	local board=$(board_name)

	case "$board" in
	apalis*)
		[ -z "$UPGRADE_BACKUP" ] && {
			jffs2reset -y
			umount /overlay
		}
		;;
	esac
}
