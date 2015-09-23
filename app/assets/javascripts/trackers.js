//= require underscore
//= require moment
//= require highstock

//use different version of jquery
var $j = jQuery.noConflict(true);

$j(function(){
	var tracker = new Tracker("websiteWrapper"); // Instantiate new objects with 'new'
		tracker.run();
	
//	html2canvas($j("#website"), {
//		useCORS: true,
//		onrendered: function(c1) {
//			console.log(c1.toDataURL());
//
//			var c2 = document.createElement("canvas");
//				c2.setAttribute('width',200);
//				c2.setAttribute('height',200);
//
//			var ctx = c2.getContext('2d');
//				ctx.drawImage(c1, 0, 0, c1.width, c1.width, 0, 0, 200, 200);
//
//			$j("#website").prepend(c2); // insert the thumbnail
//		}
//	});
	
	function drawChart(tracker){

		Highcharts.setOptions({
			//plots, change Date axis to local timezone
			global : {
				useUTC : false
			}	
		}); 				

		$j.getJSON('/trackers/' + tracker.id + '/updates', function (data) {

			var datetime = data.map(function(obj) {
				return moment.utc(obj.created_at).valueOf();
			});
			var content = data.map(function(obj) {
				return parseFloat(obj.content.replace(/[^0-9\.]+/g,''));
			});			
			var combined_data = _.zip(datetime, content)

			// Create the chart
			$j('#chart_'+tracker.id).highcharts('StockChart', {

				rangeSelector : {
					selected : 1
				},

				title : {
					text : tracker.url
				},

				credits: {
					enabled: false
				},

				series : [{
					name : "" , //tracker.url 
					data : combined_data,
					marker : {
						enabled : true,
						radius : 5
					},
					shadow : true,				
					tooltip: {
						valueDecimals: 2
					}
				}]
			});
		});
	}	
});