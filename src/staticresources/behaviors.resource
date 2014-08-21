var rules = {
	// Rich Text Editors
	'textarea.richtext': function(elt) {
		new Control.RTE(elt, 'https://c.cs14.content.force.com/servlet/servlet.ImageServer?id=015c0000000DvUu&oid=00Dc0000001JUC6&lastMod=1360817620000', { fileLister: listUserFiles });
	},
	'input.datepicker': function(elt) {
		new Control.DatePicker(elt, { icon: 'https://c.cs14.content.force.com/servlet/servlet.ImageServer?id=015c0000000DvUu&oid=00Dc0000001JUC6&lastMod=1360817620000' });
	},
	'input.timepicker': function(elt) {
		new Control.DatePicker(elt, { icon: 'images/clock.png', datePicker: false, timePicker: true });
	},
	'input.datetimepicker': function(elt) {
		new Control.DatePicker(elt, { icon: 'https://c.cs14.content.force.com/servlet/servlet.ImageServer?id=015c0000000DvUu&oid=00Dc0000001JUC6&lastMod=1360817620000', timePicker: true, timePickerAdjacent: true, use24hrs: true });
	},
	'input.datetimepicker_es': function(elt) {
		new Control.DatePicker(elt, { icon: 'https://c.cs14.content.force.com/servlet/servlet.ImageServer?id=015c0000000DvUu&oid=00Dc0000001JUC6&lastMod=1360817620000', locale:'es_AR', timePicker: true });
	},
	'input.colorpicker': function(elt) {
		new Control.ColorPicker(elt);
	},
	'input.filechooser': function(elt) {
		new Control.FileChooser(elt, listUserFiles, {
				icon: 'https://c.cs14.content.force.com/servlet/servlet.ImageServer?id=015c0000000DvUu&oid=00Dc0000001JUC6&lastMod=1360817620000',
				parentImage: 'https://c.cs14.content.force.com/servlet/servlet.ImageServer?id=015c0000000DvUu&oid=00Dc0000001JUC6&lastMod=1360817620000',
				fileImage: 'https://c.cs14.content.force.com/servlet/servlet.ImageServer?id=015c0000000DvUu&oid=00Dc0000001JUC6&lastMod=1360817620000',
				directoryImage: 'https://c.cs14.content.force.com/servlet/servlet.ImageServer?id=015c0000000DvUu&oid=00Dc0000001JUC6&lastMod=1360817620000'
			});
	},
	'.rating_bar': function(elt) {
		var code = elt.id.replace(/rating_/, '');
		new Control.RatingBar(elt, {
			starClass: 'rating_star',
			onClass: 'rating_on',
			hoverClass: 'rating_hover',
			halfClass: 'rating_half',
			onclick: rateItem(code)
			});
	},
	'.tabcontrol': function(elt) {
		new Control.TabStrip(elt, {
				activeClass: 'active',
				hoverClass: 'hover',
				disabledClass: 'disabled',
				disabled: null
			});
	},
	'.treeselect': function(elt) {
		new TreeSelect(elt);
	},
	'#livegrid': function(elt) {
		new Control.LiveGrid(elt, 10, 100, getData, {
				prefetchBuffer: 'active',
				selectable: true,
				rowIdPrefix: 'result_',
				onrowopen: openRows,
				onrowselect: selectRows,
				onscroll: scrollRows,
				sortHeader: 'livegrid_header',
				sortField: 'name',
				sortDir: 'asc',
				sortAscendImg: 'https://c.cs14.content.force.com/servlet/servlet.ImageServer?id=015c0000000DvUu&oid=00Dc0000001JUC6&lastMod=1360817620000',
				sortDescendImg: 'https://c.cs14.content.force.com/servlet/servlet.ImageServer?id=015c0000000DvUu&oid=00Dc0000001JUC6&lastMod=1360817620000',
				imageWidth: 9,
				imageHeight: 9
			});
	},
	'.treelist': function (elt) {
		new Control.TreeList(elt, {
			topOffset: 5,
			collapseIcon: 'https://c.cs14.content.force.com/servlet/servlet.ImageServer?id=015c0000000DvUu&oid=00Dc0000001JUC6&lastMod=1360817620000',
			collapseIconHover: 'https://c.cs14.content.force.com/servlet/servlet.ImageServer?id=015c0000000DvUu&oid=00Dc0000001JUC6&lastMod=1360817620000',
			expandIcon: 'https://c.cs14.content.force.com/servlet/servlet.ImageServer?id=015c0000000DvUu&oid=00Dc0000001JUC6&lastMod=1360817620000',
			expandIconHover: 'https://c.cs14.content.force.com/servlet/servlet.ImageServer?id=015c0000000DvUu&oid=00Dc0000001JUC6&lastMod=1360817620000'
			});
	}
};
Behaviour.register(rules);

function listUserFiles(directory, callback) {
	new Ajax.Request('/software/js/fileaccess.php', {
			parameters: 'a=listdir&d=' + (directory || ''),
			onComplete: function(transport) {
				try {
					callback(eval('(' + transport.responseText + ')'));
				} catch(e) {
					callback({status:'error'});
				}
			}
		});
}

function getData(offset, limit, sortField, sortDir, callback) {
    new Ajax.Request('/software/js/getData.php', {
                parameters: {
                    'offset': offset,
                    'limit': limit,
                    'sort': sortField,
                    'dir': sortDir
                },
                onComplete: function(transport) {
					try {
						callback(eval('(' + transport.responseText + ')'));
					} catch (e) {
						alert(e.message);
					}
                }
            });
}

function selectRows(e, selector) {
	var selected = selector.selectedRows();
	var desc = selected.length ? selected.join(', ') : 'None';
	$('livegrid_selected_label').innerHTML = 'Selected rows: ' + desc;
}
function openRows(e, selector) {
	alert('Open row event: ' + selector.selectedRows().join(', '));
}
function scrollRows(start, count, total) {
	$('livegrid_label').innerHTML = 'Viewing '+(start+1)+' to '+(start+count)+' of '+total+' results';
}
function rateItem(code) {
	return function(ratingbar) {
		var rating = ratingbar.rating;
		ratingbar.setLoading(true);
		new Ajax.Request('/ratings/rate.php', {
				parameters: {'m': 'rpc', 'r': rating, 'c': code},
				onSuccess: function(transport) {
					ratingbar.setLoading(false);
					try {
						var response = eval('(' + transport.responseText + ')');
						ratingbar.rating = response.rating;
						ratingbar.resetRating();
						$('rating_'+code+'_average').innerHTML = response.rating;
						$('rating_'+code+'_votes').innerHTML = response.votes;
					} catch(e) {
						alert(e.message);
					}
				},
				onFailure: function(transport) {
					ratingbar.setLoading(false);
					ratingbar.resetRating();
				}
			});
	}
}
