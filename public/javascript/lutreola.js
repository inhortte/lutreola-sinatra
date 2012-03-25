var langs = new Object();
langs["estonian"] = "ee";
langs["english"] = "en";
var gallery_url = "http://martesmartes.org/lutreola/photo_gallery/";

function closePopup() {
    $("#popup_photo").jqmHide();
    $("#popup_photo").css('display', 'none');
}

$(document).ready(function() {
    $("a[id^='flag']").click(function() {
	var which = this.id.substr(5);
	var path = "/lang/" + which + window.location.pathname;
	window.location = path;
    });

    $("div[id^='thumb'] > a").click(function() {
	var id = $(this).parent().attr("id").substr(5);
	$("#popup_photo").css('display', 'inline');
	$("#popup_photo").html("<img id=\"current_photo\" src=\"" + gallery_url + id + ".jpg\" /><br class=\"clear\"/><a href=\"javascript:closePopup()\" id=\"cancel_button\" class=\"grid_2 alpha omega\">Close</a>");
	$("#popup_photo").jqm({overlay: 0});
	$("#popup_photo").jqmShow();
	return false;
    });
});
