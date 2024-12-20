require "spec_helper"

RSpec.describe JmeterPerf::ExtendedDSL do
  include_context "test plan doc"

  describe "http_request" do
    context "#get" do
      let(:test_plan) do
        JmeterPerf.test do
          threads count: 1 do
            get name: "Home Page", url: "https://example.com/"
          end
        end
      end

      let(:fragment) { doc.search("//HTTPSamplerProxy").first }

      it "matches on method" do
        expect(fragment.search(".//stringProp[@name='HTTPSampler.method']").text).to eq "GET"
      end

      it "matches on domain" do
        expect(fragment.search(".//stringProp[@name='HTTPSampler.domain']").text).to eq "example.com"
      end

      it "matches on port" do
        expect(fragment.search(".//stringProp[@name='HTTPSampler.port']").text).to eq "443"
      end

      it "matches on protocol" do
        expect(fragment.search(".//stringProp[@name='HTTPSampler.protocol']").text).to eq "https"
      end

      it "matches on path" do
        expect(fragment.search(".//stringProp[@name='HTTPSampler.path']").text).to eq "/"
      end

      context "with options" do
        let(:test_plan) do
          JmeterPerf.test do
            threads count: 1 do
              get name: "Home Page", url: "https://example.com/", follow_redirects: false, use_keepalive: false
            end
          end
        end

        let(:fragment) { doc.search("//HTTPSamplerProxy").first }

        it "matches on domain" do
          expect(fragment.search(".//boolProp[@name='HTTPSampler.follow_redirects']").text).to eq "false"
        end

        it "matches on port" do
          expect(fragment.search(".//boolProp[@name='HTTPSampler.use_keepalive']").text).to eq "false"
        end
      end
    end

    context "#visit" do
      let(:test_plan) do
        JmeterPerf.test do
          threads count: 1 do
            visit name: "Home Page", url: "https://example.com/"
          end
        end
      end

      let(:fragment) { doc.search("//HTTPSamplerProxy").first }

      it "matches on method" do
        expect(fragment.search(".//stringProp[@name='HTTPSampler.method']").text).to eq "GET"
      end

      context "visit variations" do
        let(:test_plan) do
          JmeterPerf.test do
            threads do
              visit url: "/home?location=melbourne&location=sydney", always_encode: true
            end
          end
        end

        let(:fragment) { doc.search("//HTTPSamplerProxy").first }

        it "should match on path" do
          expect(fragment.search(".//stringProp[@name='HTTPSampler.path']").text).to eq "/home"
        end

        context "first argument" do
          it "should match on always_encode" do
            expect(fragment.search(".//boolProp[@name='HTTPArgument.always_encode']")[0].text).to eq "true"
          end

          it "should match on query param name: location" do
            expect(fragment.search(".//stringProp[@name='Argument.name']")[0].text).to eq "location"
          end

          it "should match on query param value: melbourne" do
            expect(fragment.search(".//stringProp[@name='Argument.value']")[0].text).to eq "melbourne"
          end
        end

        context "second argument" do
          it "should match on always_encode" do
            expect(fragment.search(".//boolProp[@name='HTTPArgument.always_encode']")[1].text).to eq "true"
          end

          it "should match on query param name: location" do
            expect(fragment.search(".//stringProp[@name='Argument.name']")[1].text).to eq "location"
          end

          it "should match on query param value: sydney" do
            expect(fragment.search(".//stringProp[@name='Argument.value']")[1].text).to eq "sydney"
          end
        end

        context "with query parameters" do
          let(:test_plan) do
            JmeterPerf.test do
              threads do
                visit "/home?location=melbourne", always_encode: true
              end
            end
          end

          let(:fragment) { doc.search("//HTTPSamplerProxy").first }

          it "should match on path" do
            expect(fragment.search(".//stringProp[@name='HTTPSampler.path']").text).to eq "/home"
          end
        end

        context "with https" do
          let(:test_plan) do
            JmeterPerf.test do
              threads do
                visit url: "https://example.com"
              end
            end
          end

          let(:fragment) { doc.search("//HTTPSamplerProxy").first }

          it "should match on protocol" do
            expect(fragment.search(".//stringProp[@name='HTTPSampler.protocol']").text).to eq "https"
          end
        end
      end
    end

    describe "#post" do
      let(:test_plan) do
        JmeterPerf.test do
          threads count: 1 do
            post name: "Home Page", url: "https://example.com/"
          end
        end
      end

      let(:fragment) { doc.search("//HTTPSamplerProxy").first }

      it "matches on method" do
        expect(fragment.search(".//stringProp[@name='HTTPSampler.method']").text).to eq "POST"
      end

      context "post raw_path" do
        let(:test_plan) do
          JmeterPerf.test do
            threads do
              transaction name: "TC_02" do
                post url: "/home?location=melbourne", raw_path: true
              end
            end
          end
        end

        let(:fragment) { doc.search("//HTTPSamplerProxy").first }

        it "should match on path" do
          expect(fragment.search(".//stringProp[@name='HTTPSampler.path']").text).to eq "/home?location=melbourne"
        end
      end

      context "post raw body containing xml entities" do
        let(:test_plan) do
          JmeterPerf.test do
            threads do
              post url: "http://example.com", raw_body: 'username=my_name&password=my_password&email="my name <test@example.com>"'
            end
          end
        end

        let(:fragment) { doc.search("//HTTPSamplerProxy").first }

        it "escape raw_body" do
          expect(fragment.search(".//stringProp[@name='Argument.value']").text).to eq 'username=my_name&password=my_password&email="my name <test@example.com>"'
        end
      end
    end

    describe "#submit" do
      let(:test_plan) do
        JmeterPerf.test do
          threads count: 1 do
            submit name: "Home Page", url: "https://example.com/"
          end
        end
      end

      let(:fragment) { doc.search("//HTTPSamplerProxy").first }

      it "matches on method" do
        expect(fragment.search(".//stringProp[@name='HTTPSampler.method']").text).to eq "POST"
      end

      context "submit variations" do
        let(:test_plan) do
          JmeterPerf.test do
            threads do
              submit url: "/", fill_in: {username: "tim", password: "password"}
            end
          end
        end

        let(:fragment) { doc.search("//HTTPSamplerProxy").first }

        it "should match on POST" do
          expect(fragment.search(".//stringProp[@name='HTTPSampler.method']").text).to eq "POST"
        end

        it "should have no files" do
          expect(fragment.search(".//elementProp[@name='HTTPsampler.Files']").length).to eq 0
        end
      end

      context "submit_with_files" do
        let(:test_plan) do
          JmeterPerf.test do
            threads do
              transaction name: "TC_03", parent: true, include_timers: true do
                submit url: "/", fill_in: {username: "tim", password: "password"},
                  files: [{path: "/tmp/foo", paramname: "fileup", mimetype: "text/plain"},
                    {path: "/tmp/bar", paramname: "otherfileup"}]
              end
            end
          end
        end

        let(:fragment) { doc.search("//HTTPSamplerProxy/elementProp[@name='HTTPsampler.Files']").first }

        it "should have two files" do
          expect(fragment.search("./collectionProp/elementProp[@elementType='HTTPFileArg']").length).to eq 2
        end

        it "should have one empty mimetype" do
          expect(fragment.search("./collectionProp/elementProp[@elementType='HTTPFileArg']/stringProp[@name='File.mimetype' and normalize-space(.) = '']").length).to eq 1
        end
      end
    end

    describe "#patch" do
      let(:test_plan) do
        JmeterPerf.test do
          threads count: 1 do
            patch name: "Home Page", url: "https://example.com/"
          end
        end
      end

      let(:fragment) { doc.search("//HTTPSamplerProxy").first }

      it "matches on method" do
        expect(fragment.search(".//stringProp[@name='HTTPSampler.method']").text).to eq "PATCH"
      end
    end

    describe "#head" do
      let(:test_plan) do
        JmeterPerf.test do
          threads count: 1 do
            head name: "Home Page", url: "https://example.com/"
          end
        end
      end

      let(:fragment) { doc.search("//HTTPSamplerProxy").first }

      it "matches on method" do
        expect(fragment.search(".//stringProp[@name='HTTPSampler.method']").text).to eq "HEAD"
      end
    end

    describe "#put" do
      let(:test_plan) do
        JmeterPerf.test do
          threads count: 1 do
            put name: "Home Page", url: "https://example.com/"
          end
        end
      end

      let(:fragment) { doc.search("//HTTPSamplerProxy").first }

      it "matches on method" do
        expect(fragment.search(".//stringProp[@name='HTTPSampler.method']").text).to eq "PUT"
      end
    end
  end
end
