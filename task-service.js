module.exports = srv => {

	const {
		setErrorStatus,
		setSuccessStatus
	} = require('job-scheduler-helper');

	srv.on('syncDbTables', async req => {

		let jobId = req.headers["x-sap-job-id"];
		if (!!jobId) {
			req.res.status(202).end();
		};

		req._.req.setTimeout(20 * 60000);
		
		var errors = [];
		var tx = cds.transaction(req);

		let { tasks } = req.data;
        let vProcedure;

		for (const task of tasks) {
			
			try {

				switch (task) {
                    case '':
                        break;
                    default:
						
                        vProcedure = 'START TASK "' + task + '"';
				};

                await tx.run(vProcedure);

			} catch (err) {
				errors.push(err);
			}
		}
		if (errors.length === 0) {
			
			if (!!jobId) {
				setSuccessStatus(req, 'Success');
			} else {
				return 'Success';
			}
			
		} else {
			console.log(errors);

			if (!!jobId) {
				setErrorStatus(req, errors);
			} else {
				req.error(502, JSON.stringify(errors));
			}			
		}
	});

}    