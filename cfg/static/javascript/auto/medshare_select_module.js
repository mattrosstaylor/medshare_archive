var mmsProgrammeYearId;
var mmsModuleId;
var mmsClonedModuleSelect;

document.observe( 'dom:loaded', function() {
	// if the medshare component is not selected then we don't need to do anything
	if (window['medshare_component'] == undefined) return;

	// add the image - this is easier than actually doing it with the component	
	$$(".medshare_module_select_area_programme_year").each(function(div) {
		div.insert(new Element("img", {src: "/images/medshare_archive/medshare_module_select_programme_year.jpg" }));
	});

	// get the ids for each of the components
	mmsProgrammeYearId = medshare_component+"_course_programme_year";
	mmsModuleId = medshare_component+"_course_module";

	// clone existing moduleSelectElement and deselect everything
	mmsClonedModuleSelect = Element.clone($(mmsModuleId), true);	
	mmsClonedModuleSelect.select("option").each( function(option) {
		option.removeAttribute("selected");
	});	

	// add on change events for the programme_year select
	$$("input:radio[name='" +mmsProgrammeYearId +"']").each(function(input) {
		$(input).observe('click', function() { mmsSelectProgrammeYear(this.getValue());} );
		input.up().up().toggleClassName(input.value);
	});

	// determine which radio button (if any) is selected for programme_year
	var selectedProgrammeYear;
	var selectedProgrammeYearRadio = $$("input:radio:checked[name='"+mmsProgrammeYearId+"']")[0];
	if (selectedProgrammeYearRadio != undefined) {
		selectedProgrammeYear = selectedProgrammeYearRadio.value;
	}

	// strip the unneccessary options from the module select
	$(mmsModuleId).select("option").each( function(option) {
		if (selectedProgrammeYear == undefined || medshare_programme_year_to_modules[selectedProgrammeYear].indexOf(option.value) == -1) {
			option.remove();
		}
	});

	// add placeholder option
	if (selectedProgrammeYear == undefined) {
		$(mmsModuleId).disable();
		$(mmsModuleId).insert(new Element('option').update('Select a programme/year to view modules'));
	}
	// check for non-specific modules
	else if (medshare_programme_year_to_modules[selectedProgrammeYear].length == 0) {
		$(mmsModuleId).disable();
		$(mmsModuleId).insert(new Element('option').update('This programme has no specific modules'));
	}

	// remove the labels from the input elementss
	$$(".medshare_module_select_area_programme_year input").each(function(input) {
		$(input).up().replace($(input));
	});
});


// callback for selecting a programme/year
function mmsSelectProgrammeYear(value) {

	// remove existing options
	$(mmsModuleId).select("option").each(function(option){ option.remove() });

	if (medshare_programme_year_to_modules[value].length == 0) {
		$(mmsModuleId).disable();
		$(mmsModuleId).insert(new Element('option').update('This programme has no specific modules'));
	}
	else {
		// enable the module element
		$(mmsModuleId).enable();

		// repopulate from cloned element
		mmsClonedModuleSelect.select("option").each( function(option) {
			if (medshare_programme_year_to_modules[value].indexOf(option.value) > -1) {
				var clonedOption = Element.clone(option, true);
				$(mmsModuleId).insert(clonedOption);
			}
		});

	}
}
