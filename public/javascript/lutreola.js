var langs = new Object();
langs["estonian"] = "ee";
langs["english"] = "en";
var gallery_url = "http://martesmartes.org/lutreola/photo_gallery/";

function closePopup() {
    $("#popup_photo").jqmHide();
    $("#popup_photo").css('display', 'none');
}

// coll_id 0 means all photos.
// coll_id 1 means first collection (no matter where the ids start).
function collToGallery(gallery, coll_id) {
    gallery.empty();
    $.ajax({
	url: '/gallery/collection/' + coll_id,
	dataType: 'json',
	success: function(data) {
	    $.each(data, function(i, p) {
		$('<a rel="gallery" />')
                    .append($('<img>').prop('src', p.thumb))
                    .prop('href', p.url)
                    .prop('title', p.name)
                    .appendTo(gallery);
	    });
	}
    });
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
	    $("#avail_menus").children("option[value='" + name + "']").remove();
	} else {
	    $("#menu_titles_list").append('<div id="mt' + name + '"><span class="name">' + name + '</span><input type="text" name="mt' + name + '" /></div>');
	    $("#avail_menus").append($("<option></option").attr('value',name).text(name));
	}
    });
    $("#select_collections > #select_box > select").click(function() {
	var id = this.options[this.selectedIndex].value;
	var name = this.options[this.selectedIndex].text;
	if($("#coll" + id).length > 0) { // this asks if the el exists
	    $("#coll" + id).remove();
	} else {
	    $("#collection_names_list").append('<div id="coll' + id + '"><span class="name">' + name + '</span><input type="hidden" name="coll' + id + '" value=' + id + ' /></div>');
	}
    });

    // menu
    $("#ems_sortable").sortable();
    $("#ems_sortable").disableSelection();
    $("form#menu_form").submit(function() {
	var ids = $("#ems_sortable").sortable("toArray").map(function(el) {
	    return el.substr(5);
	}).join(",");
	this.action = this.action + "?ordr=" + ids;
    });

    // collection
    $("#cps_sortable").sortable();
    $("#cps_sortable").disableSelection();
    $("form#collection_form").submit(function() {
	var ids = $("#cps_sortable").sortable("toArray").map(function(el) {
	    return el.substr(5);
	}).join(",");
	this.action = this.action + "?ordr=" + ids;
    });

    // gallery
    // admin
    if(/\/admin\/gallery/.exec(document.location)) {
	$("ul[id^='sortable']").sortable().disableSelection();
	var $tabs = $("#tabs").tabs();
	var $tab_items = $("ul:first li", $tabs).droppable({
	    accept: ".connSort li",
	    hoverClass: "ui-state-hover",
	    drop: function(event, ui) {
		var $item = $(this);
		var $list = $($item.find("a").attr("href"))
		    .find(".connSort");
		ui.draggable.hide("slow", function() {
		    $tabs.tabs("select", $tab_items.index($item));
		    $(this).appendTo($list).show("slow");
		});
	    }
	});
	$("#gallery_save").click(function() {
	    var tahendus = {};
	    $("ul[id^='sortable']").each(function(i, el) {
		tahendus[el.id.substr(8)] = 
		    $(this).find("img").map(function() {
			var m = /gallery\/photo\/(\d+)\//.exec(this.src);
			return m[1];
		    }).get().join(',');
	    });
	    $.ajax({
		url: "/admin/arrange_gallery",
		type: "POST",
		data: tahendus,
		success: function(html) {
		    $("#flash").html(html);
		}
	    });
	    return false;
	});
	$("button[id^='dphoto']").click(function() {
	    var b = $(this);
	    var id = this.id.substr(6);
	    if(confirm('Are you sure you want to delete this photo?')) {
		$.ajax({
		    url: "/admin/photo/" + id,
		    type: "DELETE",
		    success: function(html) {
			b.parents("li.photo_item").css('display','none');
		    }
		});
	    }
	    return false;
	});
	$("button[id^='dcoll']").click(function() {
	    var b = $(this);
	    var id = this.id.substr(5);
	    if(confirm('Are you sure you want to delete this collection (no photos will be deleted)?')) {
		$.ajax({
		    url: "/admin/collection/" + id,
		    type: "DELETE",
		    success: function(html) {
			b.parents("li.coll_tab").css('display','none');
		    }
		});
	    }
	    return false;
	});
    }
    // display
    if(/\/gallery/.exec(document.location) &&
       !(/\/admin\/gallery/.exec(document.location))) {
	$("#gallery").imagegallery({
	    fullscreen: false,
	    canvas: true,
	    effects: [
		'blind',
		'clip',
		'drop',
		'explode',
		'fade',
		'fold',
		'puff',
		'slide',
		'scale'
	    ],
	    show: 'slide',
	    hide: 'slide'});
	var gallery = $("#gallery");
	collToGallery(gallery, 0);
	$("a[id^='coll']").click(function() {
	    collToGallery(gallery, this.id.substr(4));
	});
    }
});
