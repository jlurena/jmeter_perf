module JmeterPerf
  class ExtendedDSL < DSL
    def response_codes_per_second(params = {}, &)
      node = JmeterPerf::Plugins::ResponseCodesPerSecond.new(params)
      attach_node(node, &)
    end

    def response_times_distribution(params = {}, &)
      node = JmeterPerf::Plugins::ResponseTimesDistribution.new(params)
      attach_node(node, &)
    end

    def response_times_over_time(params = {}, &)
      node = JmeterPerf::Plugins::ResponseTimesOverTime.new(params)
      attach_node(node, &)
    end

    def response_times_percentiles(params = {}, &)
      node = JmeterPerf::Plugins::ResponseTimesPercentiles.new(params)
      attach_node(node, &)
    end

    def transactions_per_second(params = {}, &)
      node = JmeterPerf::Plugins::TransactionsPerSecond.new(params)
      attach_node(node, &)
    end

    def latencies_over_time(params = {}, &)
      node = JmeterPerf::Plugins::LatenciesOverTime.new(params)
      attach_node(node, &)
    end

    def console_status_logger(params = {}, &)
      node = JmeterPerf::Plugins::ConsoleStatusLogger.new(params)
      attach_node(node, &)
    end

    alias_method :console, :console_status_logger

    def throughput_shaper(params = {}, &)
      node = JmeterPerf::Plugins::ThroughputShapingTimer.new(params)
      attach_node(node, &)
    end

    alias_method :shaper, :throughput_shaper

    def dummy_sampler(params = {}, &)
      node = JmeterPerf::Plugins::DummySampler.new(params)
      attach_node(node, &)
    end

    alias_method :dummy, :dummy_sampler

    def stepping_thread_group(params = {}, &)
      node = JmeterPerf::Plugins::SteppingThreadGroup.new(params)
      attach_node(node, &)
    end

    alias_method :step, :stepping_thread_group

    def ultimate_thread_group(params = {}, &)
      node = JmeterPerf::Plugins::UltimateThreadGroup.new(params)

      (params.is_a?(Array) ? params : params[:threads]).each_with_index do |group, index|
        node.doc.at_xpath("//collectionProp") <<
          Nokogiri::XML(<<-EOS.strip_heredoc).children
            <collectionProp name="index">
              <stringProp name="#{group[:start_threads]}">#{group[:start_threads]}</stringProp>
              <stringProp name="#{group[:initial_delay]}">#{group[:initial_delay]}</stringProp>
              <stringProp name="#{group[:start_time]}">#{group[:start_time]}</stringProp>
              <stringProp name="#{group[:hold_time]}">#{group[:hold_time]}</stringProp>
              <stringProp name="#{group[:stop_time]}">#{group[:stop_time]}</stringProp>
            </collectionProp>
          EOS
      end

      attach_node(node, &)
    end

    alias_method :ultimate, :ultimate_thread_group

    def composite_graph(params = {}, &)
      node = JmeterPerf::Plugins::CompositeGraph.new(params)
      attach_node(node, &)
    end

    alias_method :composite, :composite_graph

    def active_threads_over_time(params = {}, &)
      node = JmeterPerf::Plugins::ActiveThreadsOverTime.new(params)
      attach_node(node, &)
    end

    alias_method :active_threads, :active_threads_over_time

    def perfmon_collector(params = {}, &)
      node = JmeterPerf::Plugins::PerfmonCollector.new(params)
      attach_node(node, &)
    end

    alias_method :perfmon, :perfmon_collector

    def loadosophia_uploader(params = {}, &)
      node = JmeterPerf::Plugins::LoadosophiaUploader.new(params)
      attach_node(node, &)
    end

    alias_method :loadosophia, :loadosophia_uploader

    def redis_data_set(params = {}, &)
      node = JmeterPerf::Plugins::RedisDataSet.new(params)
      attach_node(node, &)
    end

    def jmx_collector(params = {}, &)
      node = JmeterPerf::Plugins::JMXCollector.new(params)
      attach_node(node, &)
    end
  end
end
