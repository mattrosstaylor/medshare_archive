var mmsProgrammeYearId;
var mmsModuleId;
var mmsClonedModuleSelect;

document.observe( 'dom:loaded', function() {
	// if the medshare component is not selected then we don't need to do anything
	if (window['medshare_component'] == undefined) return;
	
	$$(".medshare_module_select_area_programme_year").each(function(div) {
		div.insert(new Element("img", {src: "/style/images/medshare_module_select_programme_year.jpg" }));
	});

	// get the ids for each of the components
	mmsProgrammeYearId = medshare_component.id+"_raw_course_programme_year";
	mmsModuleId = medshare_component.id+"_raw_course_module";

	// clone existing moduleSelectElement and deselect everything
	mmsClonedModuleSelect = Element.clone($(mmsModuleId), true);	
	mmsClonedModuleSelect.select("option").each( function(option) {
		option.removeAttribute("selected");
	});	

	// add on change events for the programme_year select
	$$("input:radio[name='" +mmsProgrammeYearId +"']").each(function(input) {
		input.addEventListener('change', function() { mmsSelectProgrammeYear(this.getValue());} );
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

});


// callback for selecting a programme/year
function mmsSelectProgrammeYear(value) {
	// enable the module element
	$(mmsModuleId).enable();

	// remove existing options
	$(mmsModuleId).select("option").each(function(option){ option.remove() });

	// repopulate from cloned element
	mmsClonedModuleSelect.select("option").each( function(option) {
		if (medshare_programme_year_to_modules[value].indexOf(option.value) > -1) {
			var clonedOption = Element.clone(option, true);
			$(mmsModuleId).insert(clonedOption);
		}
	});
}
