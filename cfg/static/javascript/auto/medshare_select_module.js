var mmsProgrammeYearId;
var mmsModuleId;
var mmsClonedModuleSelect;

document.observe( 'dom:loaded', function() {
	// if the medshare component is not selected then we don't need to do anything
	if (window['medshare_component'] == undefined) return;

	mmsProgrammeYearId = medshare_component.id+"_course_raw_programme_year";
	mmsModuleId = medshare_component.id+"_course_raw_module";

	// clone existing moduleSelectElement and deselect everything
	mmsClonedModuleSelect = Element.clone($(mmsModuleId), true);	
	mmsClonedModuleSelect.select("option").each( function(option) {
		option.removeAttribute("selected");
	});	

	// add on change events for the programme_year select
	$$("input:radio[name='" +mmsProgrammeYearId +"']").each(function(input) {
		input.addEventListener('change', function() { mmsSelectProgrammeYear(this.getValue());} );
	});

	var selectedProgrammeYear;
	var selectedProgrammeYearRadio = $$("input:radio:checked[name='"+mmsProgrammeYearId+"']")[0];
	if (selectedProgrammeYearRadio != undefined) {
		selectedProgrammeYear = selectedProgrammeYearRadio.value;
	}


//	var selectedProgrammeYear = $$('input:radio:checked[name='"+mmsProgrammeYearId+"']")[0].value;
	// strip the unneccessary options from the module select
	$(mmsModuleId).select("option").each( function(option) {
		if (selectedProgrammeYear == undefined || medshare_programme_year_to_modules[selectedProgrammeYear].indexOf(option.value) == -1) {
			option.remove();
		}
	});

});

function mmsSelectProgrammeYear(value) {
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
