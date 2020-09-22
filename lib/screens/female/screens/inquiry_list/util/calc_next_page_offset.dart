int calcNextPageOffset({int nextPage, int perPage}) =>
    nextPage < 0 ? 0 : (nextPage - 1) * perPage;
