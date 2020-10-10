int calcNextPageOffset({int nextPage, int perPage}) =>
    nextPage <= 1 ? 0 : (nextPage - 1) * perPage;
