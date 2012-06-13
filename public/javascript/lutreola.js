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

    $("#select_box > select").click(function () {
	var menu_name = this.options[this.selectedIndex].value;
	if($("#mt" + menu_name).length > 0) {
	    $("#mt" + menu_name).remove();
	} else {
	    $("#menu_titles_list").append('<div id="mt' + menu_name + '"><span class="menu_name">' + menu_name + '</span><input type="text" name="mt' + menu_name + '" /></div>');
	}
    });

    $("#ems_sortable").sortable();
    $("#ems_sortable").disableSelection();
    $("form#menu_form").submit(function() {
	var ids = $("#ems_sortable").sortable("toArray").map(function(el) {
	    return el.substr(5);
	}).join(",");
	this.action = this.action + "?ordr=" + ids
    });
});
