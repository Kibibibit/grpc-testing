package au.com.thewindmills;

import java.time.Duration;
import java.util.concurrent.ConcurrentLinkedQueue;

import io.quarkus.grpc.GrpcService;
import io.smallrye.mutiny.Multi;
import io.smallrye.mutiny.Uni;
import io.smallrye.mutiny.operators.multi.processors.BroadcastProcessor;

@GrpcService
public class StreamGrpcService implements Stream {

    public static ConcurrentLinkedQueue<Item> items = new ConcurrentLinkedQueue<Item>();;

    public static Thread theThread = null;

    public static Multi<Item> itemMulti = null;
    public static BroadcastProcessor<Item> processor;

    private Duration timeout = Duration.ofSeconds(10);

    public static void getItem(Item item) {
        System.out.println(item);
    }

    public static void onSubscription() {
        System.out.println("Got a subscription!");
    }

    public static void onCompletion() {
        System.out.println("Complete!");
    }

    public static void onFailure() {
        System.out.println("Failure!");
    }

    public static void onTermination() {
        System.out.println("Termination!");
    }

    public static void onTimeout() {
        System.out.println("Timeout!");
    }

    @Override
    public Multi<Item> source(Empty request) {

        processor = BroadcastProcessor.create();
        itemMulti = processor.onItem().invoke(StreamGrpcService::getItem)
            .onSubscription().invoke(StreamGrpcService::onSubscription)
            .onCompletion().invoke(StreamGrpcService::onCompletion)
            .onFailure().invoke(StreamGrpcService::onFailure)
            .onTermination().invoke(StreamGrpcService::onTermination)
            .ifNoItem().after(timeout).fail();


        theThread = new Thread(new Runnable() {

            @Override
            public void run() {
                for (int i = 0; i < 200; i++) {

                    Item item = Item.newBuilder().setBody(String.valueOf(i)).build();

                    processor.onNext(item);
                    try {
                        Thread.sleep(200);
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    }
                }                
            }
            
        });

        return itemMulti;
    }

    @Override
    public Uni<Empty> sink(Multi<Item> request) {

        theThread.start();

        return Uni.createFrom().nothing();
    }

    @Override
    public Multi<Item> pipe(Multi<Item> request) {
        return null;
    }

}
