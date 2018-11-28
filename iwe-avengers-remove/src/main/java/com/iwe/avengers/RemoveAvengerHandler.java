package com.iwe.avengers;

import java.util.Optional;

import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.iwe.avenger.dao.AvengerDAO;
import com.iwe.avenger.dynamodb.entity.Avenger;
import com.iwe.avenger.lambda.response.HandlerResponse;
import com.iwe.avengers.exception.AvengerNotFoundException;

public class RemoveAvengerHandler implements RequestHandler<Avenger, HandlerResponse> {

	AvengerDAO dao = new AvengerDAO();

	@Override
	public HandlerResponse handleRequest(final Avenger avenger, final Context context) {

		final String id = avenger.getId();

		context.getLogger().log("[#] - Serching Avenger by id: " + id);

		final Optional<Avenger> avengerRetrieved = dao.search(id);

		if (avengerRetrieved.isPresent()) {

			context.getLogger().log("[#] - Avenger found " + avengerRetrieved.get().getName());

			dao.delete(avenger);

			context.getLogger().log("[#] - Avenger Remove " + avengerRetrieved.get().getName());

			return HandlerResponse.builder().build();

		}

		throw new AvengerNotFoundException("[NotFound]- Avenger id: " + id);

	}
}
