public class NormalizeDate extends TokenFilterFactory implements
ResourceLoaderAware {
  @Override
  public TokenStream create(TokenStream input) {
    return input;
  }
}
