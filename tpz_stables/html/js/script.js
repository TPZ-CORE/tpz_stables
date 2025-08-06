
function ResetAll() {

  $("#main-speed-title").text('');
  $("#main-stamina-title").text('');
  $("#main-health-title").text('');
  $("#main-acceleration-title").text('');
  $("#main-handling-age-title").text('');

  $("#main-speed-progress").css('width', "0%");
  $("#main-speed-progress-reaching-age-template").css('width', "0%");
  
  $("#main-stamina-progress").css('width', "0%");
  $("#main-stamina-progress-reaching-age-template").css('width', "0%");
  
  $("#main-health-progress").css('width', "0%");
  $("#main-health-progress-reaching-age-template").css('width', "0%");

  $("#main-acceleration-progress").css('width', "0%");
  $("#main-acceleration-progress-reaching-age-template").css('width', "0%");

  $("#main-handling-progress").css('width', "0%");
  $("#main-handling-progress-reaching-age-template").css('width', "0%");

  $("#center-side").hide();
  $("#training").hide();
}

document.addEventListener('DOMContentLoaded', function() { 
  $("#tpz_stables").fadeOut(); 
  ResetAll();

}, false);

function CloseNUI() {

  $("#tpz_stables").fadeOut();

  ResetAll();

	$.post('http://tpz_stables/close', JSON.stringify({}));
}

$(function() {

	window.addEventListener('message', function(event) {
		
    var item = event.data;

		if (item.type == "enable") {
			document.body.style.display = item.enable ? "block" : "none";

    } else if (item.action == 'updateInformation'){

      if (item.type == 'HORSE') {

        $("#main-name-title").text(item.label);

        $("#main-speed-title").text(item.locales.speed);
        $("#main-stamina-title").text(item.locales.stamina);
        $("#main-health-title").text(item.locales.health);
        $("#main-acceleration-title").text(item.locales.acceleration);
        $("#main-handling-title").text(item.locales.handling);

        $("#main-speed-value-title").text(item.statistics.speed);
        $("#main-stamina-value-title").text(item.statistics.stamina);
        $("#main-health-value-title").text(item.statistics.health);
        $("#main-acceleration-value-title").text(item.statistics.acceleration);
        $("#main-handling-value-title").text(item.statistics.handling);

        $("#main-speed-progress").css('width', (item.statistics.speed * 15 / 100) + "%");
        $("#main-stamina-progress").css('width', (item.statistics.stamina * 15 / 100) + "%");
        $("#main-health-progress").css('width', (item.statistics.health * 15 / 100) + "%");
        $("#main-acceleration-progress").css('width', (item.statistics.acceleration * 15 / 100) + "%");
        $("#main-handling-progress").css('width', (item.statistics.handling * 15 / 100) + "%");

        $("#center-side").show();
      }

      $("#tpz_stables").fadeIn(1000);


    } else if (item.action == 'displayTrainingInformation') {
      
      $("#training-title").show();
      $("#training-title-description").show();
      $("#training-horse-experience").show();

      $("#training-title").text(item.title);
      $("#training-title-description").text(item.title_description);
      $("#training-horse-experience").text(item.experience);
      $("#training-title-success").text(item.title_success);

      $("#training-title-success").fadeOut();

      if (!$('#tpz_stables').is(':visible')) {
        $("#training").show();
        $("#tpz_stables").fadeIn(1000);
      }

    } else if (item.action == 'updateTrainingCountdown') {

      $("#training-title-description").text(item.title_description);

    } else if (item.action == 'updateTrainingHorseExperience') {

      $("#training-horse-experience").text(item.experience);
      
    } else if (item.action == 'success') {

      $("#training-title").fadeOut();
      $("#training-title-description").fadeOut();
      $("#training-horse-experience").fadeOut();

      $("#training-title-success").fadeIn(2000);

    } else if (item.action == "close") {
      CloseNUI();
    }

  });


  //$("body").on("keyup", function (key) { if (key.which == 27){ CloseNUI(); } });
  
});
