#!/usr/bin/haserl
<?
	# This program is copyright © 2013 Cezary Jackiewicz and is distributed under the terms of the GNU GPL 
	# version 2.0 with a special clarification/exception that permits adapting the program to 
	# configure proprietary "back end" software provided that all modifications to the web interface
	# itself remain covered by the GPL.
	# See http://gargoyle-router.com/faq.html#qfoss for more information
	eval $( gargoyle_session_validator -c "$COOKIE_hash" -e "$COOKIE_exp" -a "$HTTP_USER_AGENT" -i "$REMOTE_ADDR" -r "login.sh" -t $(uci get gargoyle.global.session_timeout) -b "$COOKIE_browser_time"  )
	gargoyle_header_footer -h -s "system" -p "webcam" -c "internal.css" -j "webcam.js" mjpg-streamer firewall dropbear httpd_gargoyle
?>
<script>
var webcams = [];
<!--
<?
	devices=$(ls -1 /sys/class/video4linux 2>/dev/null)

	for d in $devices; do
		echo "webcams['/dev/$d'] = [];"
		echo "webcams['/dev/$d']['res'] = [];"
		webcaminfo -d "/dev/$d"
	done

	lan_ip=$(uci -p /tmp/state get network.lan.ipaddr 2>/dev/null)
	echo "currentLanIp=\"$lan_ip\";"
?>
//-->
</script>
<fieldset id="nowebcam">
	<legend class="sectionheader">Webcam</legend>
	<em><span class="nocolumn">No USB Webcam Detected.</span></em>
</fieldset>

<fieldset id="webcam">
	<legend class="sectionheader">Webcam</legend>

	<div>
		<label id="webcam_enable_label" class="leftcolumn" for="webcam_enable">Enabled:</label>
		<input id="webcam_enable" class="rightcolumn" type="checkbox" onchange='updateWebcamWanAccess()'/>
	</div>

	<div>
		<label id="webcam_wan_access_label" class="leftcolumn" for="webcam_wan_access">Enable Remote Access:</label>
		<input id="webcam_wan_access" class="rightcolumn" type="checkbox" />
	</div>

	<div>
		<label id="webcam_device_label" class="leftcolumn" for="webcam_device">Device:</label>
		<select class='rightcolumn' id='webcam_device' onchange='fillRes(this.value)' >
		</select>
	</div>

	<div>
		<label class='leftcolumn' id='webcam_res_label' for='webcam_res'>Resolution:</label>
		<select class='rightcolumn' id='webcam_res' >
		</select>
	</div>

	<div>
	<label id="webcam_fps_label" class="leftcolumn" for="webcam_fps">Frames Per Second (FPS):</label>
		<input id="webcam_fps" class="rightcolumn" type="text" size='20' maxlength='2' onkeyup='proofreadNumericRange(this,1,59)'/>
	</div>

	<div>
		<label id="webcam_yuv_label" class="leftcolumn" for="webcam_yuv">Use YUYV format:</label>
		<input id="webcam_yuv" class="rightcolumn" type="checkbox" />
	</div>

	<div>
		<label id="webcam_port_label" class="leftcolumn" for="webcam_port">Port:</label>
		<input id="webcam_port" class="rightcolumn" type="text" size='20' maxlength='5' onkeyup='proofreadPort(this)'/>
	</div>

	<div>
		<label id="webcam_username_label" class="leftcolumn" for="webcam_username">User Name:</label>
		<input id="webcam_username" class="rightcolumn" type="text" size='20'/>
		<em>(optional)</em>
	</div>
	<div>
		<label id="webcam_password_label" class="leftcolumn" for="webcam_password">Password:</label>
		<input id="webcam_password" class="rightcolumn" type="text" size='20'/>
		<em>(optional)</em>
	</div>
</fieldset>

<div id="bottom_button_container">
	<input type='button' value='Save Changes' id="save_button" class="bottom_button" onclick='saveChanges()' />
	<input type='button' value='Reset' id="reset_button" class="bottom_button" onclick='resetData()'/>
</div>

<fieldset id="webcam_preview">
	<legend class="sectionheader">Preview</legend>
	<em><span class=nocolumn id="webcam_info"></span></em>
	<div>
		<iframe id="videoframe" scrolling="no" border="0" width="320" height="240" frameBorder="0" src="about:blank" align="center"></iframe>
	</div>
</fieldset>

<script>
<!--
	resetData();
//-->
</script>

<?
	gargoyle_header_footer -f -s "system" -p "webcam"
?>
