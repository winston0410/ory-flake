local claims = std.extVar('claims');

{
  identity: {
    traits: {
      sub: claims.sub,
      email: claims.email
    },
  },
}
