RSpec.shared_context 'common' do

  given(:default_show_params) {{ id: '2265555022' }}
  let(:default_show_response) {{
    'responseHeader'=>{
      'status'=>0,
      'QTime'=>1,
      'params'=>{
        'fq'=>['access_ss:ddf_publ',
          'format:(article OR journal OR book OR thesis OR other)'],
          'fl'=>'*',
          'echoParams'=>'all',
          'q'=>'cluster_id_ss:2265555022',
          'rows'=>'1',
          'indent'=>'true',
          'q'=>'cluster_id_ss:2265555022',
          'wt'=>'ruby'}},
          'response'=>{'numFound'=>1,'start'=>0,'docs'=>[
            {

              'alert_timestamp_dt'=>'2015-10-22T12:11:50.2Z',
              'isolanguage_ss'=>['eng'],
              'isolanguage_facet'=>['eng'],
              'research_area_ss'=>['Medical science'],
              'author_affiliation_ssf'=>['[{"aff":"National Centre for Register-based Research, Department of Economics and Business, Aarhus University","au":["Nielsen, Philip Rising","Mortensen, Preben Bo","Petersen, Liselotte"]},{"aff":"Forskningsenheden BBH, Psykiatrisk Center København, Region Hovedstadens Psykiatri, Region H","au":[]},{"aff":"Endokrinologisk Afdeling I, Bispebjerg og Frederiksberg Hospitaler, Region H","au":["Benros, Michael Eriksen"]},{"aff":"Psykiatrisk Center København, Region Hovedstadens Psykiatri, Region H","au":["Sørensen, Holger Jelling"]},{"aff":"Psykiatrisk Center København afd Bispebjerg (ABN), Psykiatrisk Center København, Region Hovedstadens Psykiatri, Region H","au":["Nordentoft, Merete"]}]'],
              'toc_key_s'=>'19326203|000084|000010|000005|000000',
              'title_ts'=>['The Association between Infections and General Cognitive Ability in Young Men - A Nationwide Study'],
              'backlink_ss'=>['http://forskning.regionh.dk/en/publications/id(6cac2ff1-8008-4d12-9349-abeab536fb80).html'],
              'source_ss'=>['rdb_sbi'],
              'update_timestamp_dt'=>'2015-10-22T12:12:38.255Z',
              'access_condition_s'=>'published',
              'affiliation_ts'=>['Psykiatrisk Center København, Region Hovedstadens Psykiatri, Region H',
                'Psykiatrisk Center København afd Bispebjerg (ABN), Psykiatrisk Center København, Region Hovedstadens Psykiatri, Region H',
                'Forskningsenheden BBH, Psykiatrisk Center København, Region Hovedstadens Psykiatri, Region H',
                'Endokrinologisk Afdeling I, Bispebjerg og Frederiksberg Hospitaler, Region H',
                'National Centre for Register-based Research, Department of Economics and Business, Aarhus University'],
                '~merge_info_sf'=>'{"abstract_ts":["(rdb_sbi,*) / 555b5e2f8bfb66d26d000006"],"access_condition_s":["(rdb_sbi,*) / 555b5e2f8bfb66d26d000006"],"affiliation_ts":["(rdb_sbi,*) / 555b5e2f8bfb66d26d000006"],"author_affiliation_ssf":["(rdb_sbi,*) / 555b5e2f8bfb66d26d000006"],"author_ts":["(rdb_sbi,*) / 555b5e2f8bfb66d26d000006"],"backlink_ss":["(rdb_sbi,*) / 555b5e2f8bfb66d26d000006"],"bfi_serial_no_ss":["(rdb_sbi,*) / 555b5e2f8bfb66d26d000006"],"cluster_id_ss":["(rdb_sbi,*) / 555b5e2f8bfb66d26d000006"],"doi_ss":["(rdb_sbi,*) / 555b5e2f8bfb66d26d000006"],"format":["(rdb_sbi,*) / 555b5e2f8bfb66d26d000006"],"format_orig_s":["(rdb_sbi,*) / 555b5e2f8bfb66d26d000006"],"isolanguage_ss":["(rdb_sbi,*) / 555b5e2f8bfb66d26d000006"],"issn_ss":["(rdb_sbi,*) / 555b5e2f8bfb66d26d000006"],"journal_issue_ssf":["(rdb_sbi,*) / 555b5e2f8bfb66d26d000006"],"journal_title_ts":["(rdb_sbi,*) / 555b5e2f8bfb66d26d000006"],"journal_vol_ssf":["(rdb_sbi,*) / 555b5e2f8bfb66d26d000006"],"language_ss":["(rdb_sbi,*) / 555b5e2f8bfb66d26d000006"],"member_id_ss":["(rdb_sbi,*) / 555b5e2f8bfb66d26d000006"],"pub_date_tis":["(rdb_sbi,*) / 555b5e2f8bfb66d26d000006"],"pub_date_tsort":["(rdb_sbi,*) / 555b5e2f8bfb66d26d000006"],"research_area_ss":["(rdb_sbi,*) / 555b5e2f8bfb66d26d000006"],"review_status_s":["(rdb_sbi,*) / 555b5e2f8bfb66d26d000006"],"scientific_level_s":["(rdb_sbi,*) / 555b5e2f8bfb66d26d000006"],"source_ext_ss":["(rdb_sbi,*) / 555b5e2f8bfb66d26d000006"],"source_id_ss":["(rdb_sbi,*) / 555b5e2f8bfb66d26d000006"],"source_ss":["(rdb_sbi,*) / 555b5e2f8bfb66d26d000006"],"source_type_ss":["(rdb_sbi,*) / 555b5e2f8bfb66d26d000006"],"subformat_s":["(rdb_sbi,*) / 555b5e2f8bfb66d26d000006"],"submission_year_tis":["(rdb_sbi,*) / 555b5e2f8bfb66d26d000006"],"title_sort":["(rdb_sbi,*) / 555b5e2f8bfb66d26d000006"],"title_ts":["(rdb_sbi,*) / 555b5e2f8bfb66d26d000006"],"toc_key_s":["(rdb_sbi,*) / 555b5e2f8bfb66d26d000006"],"types_ss":["(rdb_sbi,*) / 555b5e2f8bfb66d26d000006"]}',
                'bfi_serial_no_ss'=>['5520'],
                'format_orig_s'=>'dja',
                'abstract_ts'=>['BACKGROUND: Infections and activated immune responses can affect the brain through several pathways that might also affect cognition. However, no large-scale study has previously investigated the effect of infections on the general cognitive ability in the general population. METHODS: Danish nationwide registers were linked to establish a cohort of all 161,696 male conscripts during the years 2006-2012 who were tested for cognitive ability, which was based on logical, verbal, numerical and spatial reasoning at a mean age of 19.4 years. Test scores were converted to a mean of 100.00 and with a standard deviation (SD) of 15. Data were analyzed as a cohort study with severe infections requiring hospitalization as exposure using linear regression. RESULTS: Adjusted effect sizes were calculated with non-exposure to severe infections as reference, ranging from 0.12 SD to 0.63 SD on general cognitive ability. A prior infection was associated with significantly lower cognitive ability by a mean of 1.76 (95%CI: -1.92 to -1.61; corresponding to 0.12 SD). The cognitive ability was affected the most by the temporal proximity of the last infection (P<0.001) and by the severity of infection measured by days of admission (P<0.001). The number of infections were associated with decreased cognitive ability in a dose-response relationship, and highest mean differences were found for ≥10 hospital contacts for infections (Mean: -5.54; 95%CI: -7.20 to -3.89; corresponding to 0.37 SD), and for ≥5 different types of infections (Mean: -9.44; 95%CI: -13.2 to -5.69; corresponding to 0.63 SD). Hospital contacts with infections had occurred in 35% of the individuals prior to conscription. CONCLUSIONS: Independent of a wide range of possible confounders, significant associations between infections and cognitive ability were observed. Infections or related immune responses might directly affect the cognitive ability; however, associated heritable and environmental factors might also account for the lowered cognitive ability.'],
                'journal_issue_ssf'=>['5'],
                'issn_ss'=>['19326203'],
                'scientific_level_s'=>'scientific',
                'fulltext_availability_ss'=>['UNDETERMINED'],
                'source_id_ss'=>['rdb_sbi:6cac2ff1-8008-4d12-9349-abeab536fb80'],
                'journal_vol_ssf'=>['10'],
                'source_type_ss'=>['research'],
                'access_ss'=>['dtupub',
                  'ddf_publ',
                  'dtu'],
                  'journal_title_ts'=>['P L O S One'],
                  'journal_title_facet'=>['P L O S One'],
                  'subformat_s'=>'journal_article',
                  'review_status_s'=>'peer_review',
                  'submission_year_tis'=>[2015],
                  'member_id_ss'=>['555b5e2f8bfb66d26d000006'],
                  'language_ss'=>['eng'],
                  'format'=>'article',
                  'types_ss'=>['article:journal_article'],
                  'doi_ss'=>['10.1371/journal.pone.0124005'],
                  'pub_date_tis'=>[2015],
                  'cluster_id_ss'=>['2265555022'],
                  'author_ts'=>['Benros, Michael Eriksen',
                    'Sørensen, Holger Jelling',
                    'Nielsen, Philip Rising',
                    'Nordentoft, Merete',
                    'Mortensen, Preben Bo',
                    'Petersen, Liselotte'],
                    'author_facet'=>['Benros, Michael Eriksen',
                      'Sørensen, Holger Jelling',
                      'Nielsen, Philip Rising',
                      'Nordentoft, Merete',
                      'Mortensen, Preben Bo',
                      'Petersen, Liselotte'],
                      'source_ext_ss'=>['dads:rdb_sbi'],
                      'id'=>'5037',
                      '_version_'=>1516806228223721473,
                      'timestamp'=>'2015-11-03T08:25:39.751Z'
                      }
                      ]
                      }
                      }
                    }



                      let(:response_with_highlighting) { {
                        'responseHeader'=>{
                          'status'=>0,
                          'QTime'=>10,
                          'params'=>{
                            'hl.highlightMultiTerm'=>'true',
                            'indent'=>'true',
                            'start'=>'1',
                            'q'=>'journal_title_ts:"diabetic medicine"',
                            'hl.simple.pre'=>'<em>',
                            'hl.simple.post'=>'</em>',
                            'hl.fl'=>'journal_title_ts',
                            'wt'=>'ruby',
                            'hl'=>'true',
                            'rows'=>'1'}},
                            'response'=>{'numFound'=>28949,'start'=>1,'maxScore'=>7.335848,'docs'=>[
                              {
                                'access_ss'=>['dtupub',
                                  'aub',
                                  'Pure_test',
                                  'dtu'],
                                  'alert_timestamp_dt'=>'2015-08-09T05:52:33.47Z',
                                  'isolanguage_ss'=>['eng'],
                                  'isolanguage_facet'=>['eng'],
                                  'title_ts' => ['sample title'],
                                  'journal_title_ts'=>['Diabetic Medicine',
                                    'Diabetic Med',
                                    'Diabet Med',
                                    'Diab. Med'],
                                  'journal_title_facet'=>['Diabetic Medicine',
                                    'Diabetic Med',
                                    'Diabet Med',
                                    'Diab. Med'],
                                  'subformat_s'=>'journal_article',
                                  'member_id_ss'=>['54591b4de1880dc213155b22'],
                                  'source_ss'=>['crossref'],
                                  'format'=>'article',
                                  'update_timestamp_dt'=>'2015-08-14T17:59:55.415Z',
                                  'language_ss'=>['eng'],
                                  'types_ss'=>['bib:article:journal_article'],
                                  'journal_issue_ssf'=>['9'],
                                  'issn_ss'=>['07423071'],
                                  'fulltext_availability_ss'=>['UNDETERMINED'],
                                  'cluster_id_ss'=>['2247493145'],
                                  'source_id_ss'=>['crossref:10.1111/dme.2012.29.issue-9'],
                                  'journal_vol_ssf'=>['29'],
                                  'superformat_s'=>'bib',
                                  'source_ext_ss'=>['dads:crossref'],
                                  'source_type_ss'=>['other'],
                                  'id'=>'1410238872',
                                  '_version_'=>1518364591894036481,
                                  'timestamp'=>'2015-11-20T13:15:14.229Z',
                                  'score'=>7.335848}]
                                },
                                'highlighting'=>{
                                  '1410238872'=>{
                                    'journal_title_ts'=>['<em>Diabetic</em> <em>Medicine</em>']}}}
                                  }
                                end
