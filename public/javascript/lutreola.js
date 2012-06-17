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

    $("#select_menus > #select_box > select").click(function () {
	var name = this.options[this.selectedIndex].value;
	if($("#mt" + name).length > 0) { // this asks if the el exists
	    $("#mt" + name).remove();
	} else {
	    $("#menu_titles_list").append('<div id="mt' + name + '"><span class="name">' + name + '</span><input type="text" name="mt' + name + '" /></div>');
	}
    });
    $("#select_collections > #select_box > select").click(function() {
	alert("#select_collections > #select_box > select");
	var id = this.options[this.selectedIndex].value;
	var name = this.options[this.selectedIndex].text;
	if($("#coll" + id).length > 0) { // this asks if the el exists
	    $("#coll" + id).remove();
	} else {
	    $("#collection_names_list").append('<div id="coll' + id + '"><span class="name">' + name + '</span><input type="hidden" name="coll' + id + '" value=' + id + ' /></div>');
	}
    });

    $("#ems_sortable").sortable();
    $("#ems_sortable").disableSelection();
    $("form#menu_form").submit(function() {
	var ids = $("#ems_sortable").sortable("toArray").map(function(el) {
	    return el.substr(5);
	}).join(",");
	this.action = this.action + "?ordr=" + ids;
    });
    $("#cps_sortable").sortable();
    $("#cps_sortable").disableSelection();
    $("form#collection_form").submit(function() {
	var ids = $("#cps_sortable").sortable("toArray").map(function(el) {
	    return el.substr(5);
	}).join(",");
	this.action = this.action + "?ordr=" + ids;
    });
});
